set projloc=C:\Users\Rida\Desktop\abcdrent\
set conn=-S DESKTOP-6CTH65L -U sa -P root123123 -w 300
cls
echo Begining on top of MS Sqlserver DBMS engine...

osql %conn% -i %projloc%\sql\tables.sql -o %projloc%\log\abcrent.log

echo database created...

echo End of batch file....


