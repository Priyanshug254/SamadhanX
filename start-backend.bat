@echo off
title SamadhanX Backend (Port 8088)
echo ===================================================
echo Starting SamadhanX Spring Boot Backend on Port 8088...
echo ===================================================
cd /d "%~dp0backend"
if exist "target\samadhanx-backend-1.0.0-SNAPSHOT.jar" (
    java -jar target\samadhanx-backend-1.0.0-SNAPSHOT.jar
) else (
    .\maven\apache-maven-3.9.9\bin\mvn.cmd spring-boot:run
)
pause
