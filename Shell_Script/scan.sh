#!/bin/bash


CODEBASE=""

hasJack() {
   test -n "$(find $1 -name *.jack)" 
}
hasJar() {
   test -n "$(find $1 -name classes-full-debug.jar)"
}

both() {
   hasJack $1 && hasJar $1
}

empty() {
   ! (hasJar $1 || hasJack $1)
}


#hasJack Calculator_intermediates
#echo hasjack:$?
#hasJar Calculator_intermediates
#echo hasJar:$?
#both Calculator_intermediates
#echo both:$?
#empty Calculator_intermediates
#echo empty:$?
#exit


jk=0
ja=0
b=0
e=0

rm out.csv
echo "Type , Module_Path" >> out.csv
for i in $(find -maxdepth 2 -mindepth 1 -type d)
#for i in FrameworkCoreTests_keyset_sa_ua_ub_intermediates
do
   #CODEBASE="echo `$i`"
   if (hasJack $i) ; then
      echo "Jack , `echo ${i}`" >> out.csv
#      echo `$i` >> out.csv
#      echo jack:$i
      (( jk++ ))
   fi    

   if (hasJar $i) ; then
      echo "Jar , `echo ${i}`" >> out.csv
 #     echo jar:$i
      (( ja++ ))
   fi

   if (both $i) ; then
      echo "both , `echo ${i}`" >> both_out.csv
  #    echo both:$i
      (( b++ ))
   fi

   if (empty $i); then
      echo "empty , `echo ${i}`" >> empty_out.csv

   #  echo empty:$i
      (( e ++ ))
   fi
done

cat both_out.csv >> out.csv
cat empty_out.csv >> out.csv

rm both_out.csv
rm empty_out.csv

echo jack num=$jk
echo jar num=$ja
echo both num=$b
echo empty num=$e
