#!/bin/bash

# docker login -u iamapikey -p token  my-registry/registry

img_incl='cmd-user.*|cmd-.*'
img_excl='.*_stage|.*_release'

all_images=`bx cr images | awk '{print $1":"$2}' | sort -t: -k2,2`
images=()
for i in $all_images; do
    img=`echo $i | awk -F ':' ' { print $1 } ' `
    ver=`echo $i | awk -F ':' ' { print $2 } ' `
    if [[ $img =~ $img_incl ]] && ! [[ $img =~ $img_excl ]] ; then
        echo adding $img
        images+=($i)
    fi
done

echo IMAGES $images ${images[@]}

for i in ${images[@]}; do
    img=`echo $i | awk -F ':' ' { print $1 } ' `
    ver=`echo $i | awk -F ':' ' { print $2 } ' `
    echo docker tag $img:$ver $img:${ver}_release
done
exit 0;


# docker tag blah:1.0.0 my-registry/registry/blah:1.0.0_a
# docker push  my-registry/registry/blah:1.0.0_a