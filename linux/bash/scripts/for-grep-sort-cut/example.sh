# get the average
i=0
j=0
for n in `cat example.csv | grep 英语 | cut -d',' -f4`
do 
	i=$((i+n))
	j=$((j+1))
done
printf "There were totally %d students in the exam.\nThe average score is %d.\n" $j $((i/j))

# sort the English exam result, and get the top 5
echo
echo the top 5 students are:
cat example.csv | grep 英语 | sort -n -t',' -k4 -r | head -5 | cut -d',' -f2,4
