#!/bin/bash
repo_list=$1
repo_array=($(echo $repo_list | tr "," "\n"))
tag_list=$2
tag_prefix=($(echo $tag_list | tr "," "\n")) 
retain_img_no=$3 
for repo in ${repo_array[@]}
do
        echo $repo
        for tags in ${tag_prefix[@]}
        do
                image_list=$(aws ecr describe-images --repository-name $repo --output text --query 'sort_by(imageDetails,& imagePushedAt)[*].imageTags[0]')
                echo $image_list | tr " " "\n" | grep ^"$tags" > image_array
                cat image_array | head -n -$(($retain_img_no)) > image_cleanup
                while read -r image; do aws ecr batch-delete-image --repository-name $repo --image-ids imageTag=$image; done < image_cleanup
        done
done
















