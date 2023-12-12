# USE finance_loan;
# SET SQL_SAFE_UPDATES = 0;

# ------------------------------------------------------------------------------------------ #
### DATA CLEANING ###

/* ALTER TABLE financial_loan
		ADD COLUMN (IssueDate DATE
					LastCreditPullDate DATE,
					LastPaymentDate DATE,
					NextPaymentDate DATE);
*/

/* UPDATE financial_loan
		SET IssueDate = str_to_date(issue_date, '%m/%d/%Y'),
			LastCreditPullDate = STR_TO_DATE(last_credit_pull_date, '%m/%d/%Y'),
			LastPaymentDate = STR_TO_DATE(last_payment_date, '%m/%d/%Y'),
			NextPaymentDate = STR_TO_DATE(next_payment_date, '%m/%d/%Y');
*/

/* ALTER TABLE financial_loan
		DROP COLUMN issue_date, 
		DROP COLUMN last_credit_pull_date, 
		DROP COLUMN last_payment_date, 
		DROP COLUMN next_payment_date;
*/

# SELECT IssueDate, LastCreditPullDate, LastPaymentDate, NextPaymentDate
# FROM financial_loan;

# ------------------------------------------------------------------------------------------ #
### A. BANK LOAN SUMMARY ###

# I - KPI's

/* 1.1. Total Loan Applications

SELECT COUNT(id) AS total_applications
FROM financial_loan;
*/

/* 1.2. MTD Loan Application

SELECT 	COUNT(id) AS Total_Applications
FROM	financial_loan
WHERE	MONTH(IssueDate) = 12;
*/

/* 1.3. PMTD Loan Application

SELECT COUNT(id) AS Total_Applications
FROM financial_loan
WHERE MONTH(IssueDate) = 11;
*/

/* 1.4. Total Funded Amount

SELECT SUM(loan_amount) AS Total_Funded_Amount
FROM financial_loan;
*/

/* 1.5. MTD Total Funded Amount

SELECT SUM(loan_amount) AS Total_Funded_Amount
FROM financial_loan
WHERE MONTH(IssueDate) = 12;
*/

/* 1.6. PMTD Total Funded Amount 

SELECT SUM(loan_amount) AS Total_Funded_Amount
FROM financial_loan
WHERE MONTH(IssueDate) = 11;
*/ 

/* 1.7. Total Amount Received

SELECT SUM(total_payment) AS Total_Amount_Received
FROM financial_loan;
*/

/* 1.8. MTD Amount Received

SELECT SUM(total_payment) AS Total_Amount_Received
FROM financial_loan
WHERE MONTH(IssueDate) = 12;
*/

/* 1.9. PMTD Amount Received

SELECT SUM(total_payment) AS Total_Amount_Received
FROM financial_loan
WHERE MONTH(IssueDate) = 11;
*/

 /* 1.10. Month-to-month Measure

  SELECT	Month,
			ROUND((Loan_Applications - LAG(Loan_Applications) OVER(ORDER BY Month)) *100
				/ LAG(Loan_Applications) OVER(ORDER BY Month), 2) AS Loan_Applications_Changes,
			ROUND((Funded_Amount - LAG(Funded_Amount) OVER(ORDER BY Month))*100
				/ LAG(Funded_Amount) OVER(ORDER BY Month), 2) AS Funded_Amount_Changes,
			ROUND((Amount_Received - LAG(Amount_Received) OVER(ORDER BY Month))*100
				/ LAG(Amount_Received) OVER(ORDER BY Month), 2) AS Amount_Received_Changes
	FROM (  
		  SELECT	MONTH(IssueDate) AS Month,
					COUNT(id) AS Loan_Applications,
					SUM(loan_amount) AS Funded_Amount,
					SUM(total_payment) AS Amount_Received
			FROM	financial_loan
		GROUP BY	Month
		ORDER BY	Month ASC) AS m2m
        
*/

# ------------------------------------------------------------------------------------------ #
# II - Interest Rate

/* 2.1. Average Interest Rate

SELECT ROUND((AVG(int_rate)*100), 2) AS Avg_Interest_Rate
FROM financial_loan
*/

/* 2.2. MTD Average Interest Rate 

SElECT ROUND((AVG(int_rate)*100), 2) AS Avg_Interest_Rate
FROM financial_loan
WHERE MONTH(IssueDate) = 12;
*/

/* 2.3. PMTD Average Interest Rate

SELECT ROUND((AVG(int_rate)*100), 2) AS Avg_Interest_Rate
FROM financial_loan
WHERE MONTH(IssueDate) = 11;
*/

# ------------------------------------------------------------------------------------------ #
# III - Average of Debt to Income (DTI)

/* 3.1 Avg of DTI

SELECT ROUND((AVG(dti)*100), 2) AS Avg_Dti
FROM financial_loan;
*/

/* 3.2. MTD Avg of DTI

SELECT ROUND((AVG(dti)*100), 2) AS Avg_Dti
FROM financial_loan
WHERE MONTH(IssueDate) = 12;
*/

/* 3.3. PMTD Avg of DTI

SELECT ROUND((AVG(dti)*100), 2) AS Avg_Dti
FROM financial_loan
WHERE MONTH(IssueDate) = 11;
*/

# ------------------------------------------------------------------------------------------ #
/* IV - Good Loan Issued

SELECT ROUND(COUNT(CASE WHEN loan_status = "Fully Paid" OR loan_status = "Current" 
					THEN id END)*100 / COUNT(id), 2) AS Good_Loan_Percentage,
		COUNT(CASE WHEN loan_status = "Fully Paid" OR loan_status = "Current" 
				THEN id END) AS Good_Loan_Applications,
		SUM(CASE WHEN loan_status = "Fully Paid" OR loan_status = "Current"
			THEN loan_amount END) AS Good_Loan_Funded_Amount,
		SUM(CASE WHEN loan_status = "Fully Paid" OR loan_status = "Current"
			THEN total_payment END) AS Good_load_Amount_Received
FROM financial_loan;
*/

# ------------------------------------------------------------------------------------------ #
/* V - Bad Loan Issued

SELECT 	ROUND(COUNT(CASE WHEN loan_status = "Charged Off" THEN id END)*100/ COUNT(id), 2) AS Bad_Loan_Percentage,
		COUNT(CASE WHEN loan_status = "Charged Off" THEN id END) AS Bad_Loan_Applications,
        SUM(CASE WHEN loan_status = "Charged Off" THEN loan_amount END) AS Bad_Loan_Funded_Amount,
        SUM(CASE WHEN loan_status = "Charged Off" THEN total_payment END) AS Bad_Loan_Amount_Received
FROM financial_loan;
*/

# ------------------------------------------------------------------------------------------ #
# VI - Loan Status

/* 6.1. Summary of Loan Status

  SELECT 	loan_status, 
			COUNT(id) AS Loan_Applications,
            SUM(loan_amount)	AS	Total_Funded_Amount,
            SUM(total_payment)	AS	Total_Amount_Received,
            ROUND(AVG(int_rate)*100, 2) AS Average_Interest_Rate,
            ROUND(AVG(dti)*100, 2)		AS Average_DTI
	FROM 	financial_loan
GROUP BY	loan_status
ORDER BY	loan_status DESC;
*/

/* 6.2. MTD Loan Status

  SELECT	loan_status,
			SUM(loan_amount) AS MTD_Funded_Amount,
            SUM(total_payment) AS MTD_Amount_Received
	FROM	financial_loan
   WHERE	MONTH(IssueDate) = 12
GROUP BY	loan_status
ORDER BY	loan_status DESC;
*/

/* 6.3. PMTD Loan Status

  SELECT	loan_status,
			SUM(loan_amount) AS MTD_Funded_Amount,
            SUM(total_payment) AS MTD_Amount_Received
	FROM	financial_loan
   WHERE	MONTH(IssueDate) = 11
GROUP BY	loan_status
ORDER BY	loan_status DESC;
*/

# ------------------------------------------------------------------------------------------ #
### B - ANK LOAN REPORT ###

/* I - Month 

  SELECT	MONTH(IssueDate) AS Month_Number,
			MONTHNAME(IssueDate) AS Month_Name,
			COUNT(id) AS Loan_Applications,
            SUM(loan_amount) AS Funded_Amount,
            SUM(total_payment) AS Amount_Received
	FROM	financial_loan
GROUP BY	Month_Number, Month_Name
ORDER BY	Month_Number ASC;
*/

/* II - State

  SELECT	address_state AS State,
			COUNT(id) AS Loan_Applications,
            SUM(loan_amount) AS Funded_Amount,
            SUM(total_payment) AS Amount_Received
	FROM	financial_loan
GROUP BY	State
ORDER BY	Loan_Applications DESC;
*/

/* III - Term

  SELECT	term,
			COUNT(id) AS Loan_Applications,
            SUM(loan_amount) AS Funded_Amount,
            SUM(total_payment) AS Amount_Received
	FROM 	financial_loan
GROUP BY	term;
*/

/* IV - Employee Length

  SELECT	emp_length AS Employee_Length,
			COUNT(id) AS Loan_Applications,
            SUM(loan_amount) AS Funded_Amount,
            SUM(total_payment) AS Amount_Received
	FROM	financial_loan
GROUP BY	Employee_Length
ORDER BY	Employee_Length;

*/

/* V - Purpose 

  SELECT	purpose AS Purpose,
			COUNT(id) AS Loan_Applications,
            SUM(loan_amount) AS Funded_Amount,
            SUM(total_payment) AS Amount_Received
	FROM	financial_loan
GROUP BY	Purpose;
*/

/* VI - Home Ownership

  SELECT	home_Ownership AS Home_Ownership,
			COUNT(id) AS Loan_Applications,
            SUM(loan_amount) AS Funded_Amount,
            SUM(total_payment) AS Amount_Received
	FROM	financial_loan
GROUP BY	Home_Ownership;
*/

# ------------------------------------------------------------------------------------------ #
