0. export a xlsx file from jw.swfu.edu.cn:8089 with only name and studid in it
	
	> id,name

1. make a csv file

	```sh
	xlsx2csv 文件1630715018105.xlsx | \ 
	awk -F, '{print $1","$1"," $1"@where.com,COURSE,1,COHORT,"$2}' \
	> 212201-netb.csv
	```

	Open this csv file in emacs,

	- Insert a comma (,) between lastname and firstname;
	- Add header line.

2. add a new cohort in moodle -> site admin -> users -> cohorts

	https://cs6.swfu.edu.cn/moodle/cohort/edit.php?contextid=1

3. site admin -> users -> upload users (csv file)

4. Course -> Participants -> enrolment methods -> cohort sync
