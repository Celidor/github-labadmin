#!/bin/bash
# USE WITH CARE - WILL DELETE ALL PUBLIC GITHUB REPOSITORIES IN USER ACCOUNT
#set github variables from file access-tokens.sh using format
#NAMEPREFIX="your-prefix"
#API_TOKEN_1="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
#API_TOKEN_2="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
source access-tokens.sh
for i in `seq 1 14`;
do
  echo "looking for repositories in github.com/$NAMEPREFIX$i"
  API_TOKEN="API_TOKEN_$i"  
  API_TOKEN=${!API_TOKEN}

  REPOS=( $(curl -s "https://api.github.com/users/$NAMEPREFIX$i/repos?per_page=100" | grep -o 'git@[^"]*') )
  
  for REPO in "${REPOS[@]}"
  do
    REPONAME=${REPO#"git@github.com:"}
    REPONAME=${REPONAME%".git"}
    echo "deleting repository" $REPONAME
    echo "you have 5 seconds to Ctrl-C"
    sleep 5
    curl -vL \
      -H "Authorization: token $API_TOKEN" \
      -H "Content-Type: application/json" \
      -X DELETE https://api.github.com/repos/$REPONAME \
     | jq
  done

done
