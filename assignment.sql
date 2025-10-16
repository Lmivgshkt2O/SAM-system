--For better view:
--SET LINESIZE 200
--SET PAGESIZE 100

--Initialization table 
DROP TABLE Department CASCADE CONSTRAINTS;
DROP TABLE Staff CASCADE CONSTRAINTS;
DROP TABLE Shift CASCADE CONSTRAINTS;
DROP TABLE Attendance CASCADE CONSTRAINTS;
DROP TABLE Leave CASCADE CONSTRAINTS;
DROP TABLE Payroll CASCADE CONSTRAINTS;

--Creating table:

-- DEPARTMENT Table
CREATE TABLE Department (
    Department_ID VARCHAR2(10) PRIMARY KEY,
    Department_Name VARCHAR2(20) NOT NULL UNIQUE
    -- Manager_ID VARCHAR2(10) UNIQUE,
    -- FOREIGN KEY (Manager_ID) REFERENCES Staff(Staff_ID)
);

-- STAFF Table
CREATE TABLE Staff (
    Staff_ID VARCHAR2(10) PRIMARY KEY,
    Staff_FirstName VARCHAR2(10) NOT NULL,
    Staff_LastName VARCHAR2(10) NOT NULL,
    Staff_PhoneNum VARCHAR2(10),
    Staff_Address VARCHAR2(18),
    Staff_Email VARCHAR2(25) UNIQUE,
    Staff_DOB DATE,
    Manager_ID VARCHAR2(10),
    Department_ID VARCHAR2(10),
    FOREIGN KEY (Manager_ID) REFERENCES Staff(Staff_ID), 
    FOREIGN KEY (Department_ID) REFERENCES Department(Department_ID)
);



-- SHIFT Table
CREATE TABLE Shift (
    Shift_ID VARCHAR2(10) PRIMARY KEY,
    Shift_Time VARCHAR2(20) NOT NULL,
    Shift_Date DATE NOT NULL
);

-- LEAVE Table
CREATE TABLE Leave (
    Leave_ID VARCHAR2(10) PRIMARY KEY,
    Staff_ID VARCHAR2(10) NOT NULL,
    Leave_Reason VARCHAR2(20),
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    Status VARCHAR2(10),
    FOREIGN KEY (Staff_ID) REFERENCES Staff(Staff_ID)
);


-- ATTENDANCE Table
CREATE TABLE Attendance (
    Attendance_ID VARCHAR2(10) PRIMARY KEY,
    Staff_ID VARCHAR2(10) NOT NULL,
    Shift_ID VARCHAR2(10) NOT NULL,
    Attendance_Status VARCHAR2(15),
    Extra_Time NUMBER(4,2) NOT NULL,
    Late_Reason VARCHAR2(20),
    FOREIGN KEY (Staff_ID) REFERENCES Staff(Staff_ID),
    FOREIGN KEY (Shift_ID) REFERENCES Shift(Shift_ID)
);


-- PAYROLL Table
CREATE TABLE Payroll (
    Payroll_ID VARCHAR2(10) PRIMARY KEY,
    Staff_ID VARCHAR2(10) NOT NULL,
    Month VARCHAR2(10) NOT NULL,
    Year NUMBER(4) NOT NULL,
    Base_Salary NUMBER(10,2) NOT NULL,
    Overtime_Payment NUMBER(8,2) DEFAULT 0,
    Deduction NUMBER(8,2) DEFAULT 0,
    FOREIGN KEY (Staff_ID) REFERENCES Staff(Staff_ID)
);



-- CREATE OR REPLACE TRIGGER trg_calc_net_salary
-- BEFORE INSERT OR UPDATE ON Payroll
-- FOR EACH ROW
-- BEGIN
--    :NEW.Net_Salary := :NEW.Base_Salary + :NEW.Overtime_Payment - :NEW.Deduction;
-- END;
-- /


/*
-- OVERTIME Table
CREATE TABLE Overtime (
    Attendance_ID VARCHAR2(10) PRIMARY KEY,  
    Extra_Time NUMBER(4,2), 
    Extra_Payment NUMBER(8,2) DEFAULT 0,
    FOREIGN KEY (Attendance_ID) REFERENCES Attendance(Attendance_ID) 
); */


/*
-- LATE Table
CREATE TABLE Late (
    Attendance_ID VARCHAR2(10) PRIMARY KEY,  
    Late_Reason VARCHAR2(100),
    FOREIGN KEY (Attendance_ID) REFERENCES Attendance(Attendance_ID)
);
*/

--Insert records into Department
INSERT INTO Department (Department_ID, Department_Name) VALUES ('D001', 'Human Resources');
INSERT INTO Department (Department_ID, Department_Name) VALUES ('D002', 'IT Support');
INSERT INTO Department (Department_ID, Department_Name) VALUES ('D003', 'Finance');
INSERT INTO Department (Department_ID, Department_Name) VALUES ('D004', 'Marketing');
INSERT INTO Department (Department_ID, Department_Name) VALUES ('D005', 'Operations');
INSERT INTO Department (Department_ID, Department_Name) VALUES ('D006', 'Logistics');

--Insert records into Staff Way1 (Delete FOREIGN KEY (Manager_ID) REFERENCES Staff(Staff_ID))


/*-- Insert Staff without a manager first (NULL Manager_ID)
INSERT INTO Staff (Staff_ID, Staff_FirstName, Staff_LastName, Staff_PhoneNum, Staff_Address, Staff_Email, Manager_ID, Staff_DOB, Department_ID) VALUES ('S001', 'Alice', 'Lee', '123456789', '10 Jalan Bukit', 'alice.lee@company.com', NULL, TO_DATE('10/04/1990', 'DD/MM/YYYY'), 'D001');
INSERT INTO Staff (Staff_ID, Staff_FirstName, Staff_LastName, Staff_PhoneNum, Staff_Address, Staff_Email, Manager_ID, Staff_DOB, Department_ID) VALUES ('S003', 'Carol', 'Tan', '142233445', '33 Jalan Kuching', 'carol.tan@company.com', NULL, TO_DATE('18/05/1992', 'DD/MM/YYYY'), 'D002');
INSERT INTO Staff (Staff_ID, Staff_FirstName, Staff_LastName, Staff_PhoneNum, Staff_Address, Staff_Email, Manager_ID, Staff_DOB, Department_ID) VALUES ('S005', 'Eva', 'Wong', '112233445', '18 Jalan Ipoh', 'eva.wong@company.com', NULL, TO_DATE('15/01/1993', 'DD/MM/YYYY'), 'D003');
INSERT INTO Staff (Staff_ID, Staff_FirstName, Staff_LastName, Staff_PhoneNum, Staff_Address, Staff_Email, Manager_ID, Staff_DOB, Department_ID) VALUES ('S008', 'Henry', 'Goh', '195544332', '28 Jalan Puduri', 'henry.goh@company.com', NULL, TO_DATE('02/03/1990', 'DD/MM/YYYY'), 'D004');
INSERT INTO Staff (Staff_ID, Staff_FirstName, Staff_LastName, Staff_PhoneNum, Staff_Address, Staff_Email, Manager_ID, Staff_DOB, Department_ID) VALUES ('S009', 'Ivy', 'Koh', '128877665', '31 Jalan Imbi', 'ivy.koh@company.com', NULL, TO_DATE('21/06/1995', 'DD/MM/YYYY'), 'D005');
INSERT INTO Staff (Staff_ID, Staff_FirstName, Staff_LastName, Staff_PhoneNum, Staff_Address, Staff_Email, Manager_ID, Staff_DOB, Department_ID) VALUES ('S011', 'Ken', 'Tan', '145566778', '15 Jalan Raja Laut', 'ken.tan@company.com', NULL, TO_DATE('14/02/1990', 'DD/MM/YYYY'), 'D006');

-- Insert Staff who have managers (ensuring their manager's Staff_ID exists)
INSERT INTO Staff (Staff_ID, Staff_FirstName, Staff_LastName, Staff_PhoneNum, Staff_Address, Staff_Email, Manager_ID, Staff_DOB, Department_ID) VALUES ('S002', 'Ben', 'Ng', '139876543', '22 Jalan Ampang', 'ben.ng@company.com', 'S001', TO_DATE('22/12/1988', 'DD/MM/YYYY'), 'D001');
INSERT INTO Staff (Staff_ID, Staff_FirstName, Staff_LastName, Staff_PhoneNum, Staff_Address, Staff_Email, Manager_ID, Staff_DOB, Department_ID) VALUES ('S004', 'Daniel', 'Lim', '155566778', '12 Jalan Sultan', 'daniel.lim@company.com', 'S003', TO_DATE('09/07/1991', 'DD/MM/YYYY'), 'D002');
INSERT INTO Staff (Staff_ID, Staff_FirstName, Staff_LastName, Staff_PhoneNum, Staff_Address, Staff_Email, Manager_ID, Staff_DOB, Department_ID) VALUES ('S006', 'Farid', 'Rahman', '169988776', '25 Jalan Cheras', 'farid.rahman@company.com', 'S005', TO_DATE('03/11/1989', 'DD/MM/YYYY'), 'D003');
INSERT INTO Staff (Staff_ID, Staff_FirstName, Staff_LastName, Staff_PhoneNum, Staff_Address, Staff_Email, Manager_ID, Staff_DOB, Department_ID) VALUES ('S007', 'Grace', 'Teo', '176655443', '50 Jalan Tun Razak', 'grace.teo@company.com', 'S008', TO_DATE('28/08/1994', 'DD/MM/YYYY'), 'D004');
INSERT INTO Staff (Staff_ID, Staff_FirstName, Staff_LastName, Staff_PhoneNum, Staff_Address, Staff_Email, Manager_ID, Staff_DOB, Department_ID) VALUES ('S010', 'Jack', 'Yap', '183344552', '42 Jalan Sentul', 'jack.yap@company.com', 'S009', TO_DATE('19/09/1987', 'DD/MM/YYYY'), 'D005');
INSERT INTO Staff (Staff_ID, Staff_FirstName, Staff_LastName, Staff_PhoneNum, Staff_Address, Staff_Email, Manager_ID, Staff_DOB, Department_ID) VALUES ('S012', 'Lily', 'Wong', '132233441', '60 Jalan Maluri', 'lily.wong@company.com', 'S011', TO_DATE('01/12/1991', 'DD/MM/YYYY'), 'D006');
*/


--Insert records into Staff
INSERT INTO Staff (Staff_ID, Staff_FirstName, Staff_LastName, Staff_PhoneNum, Staff_Address, Staff_Email, Manager_ID, Staff_DOB, Department_ID) VALUES ('S001', 'Alice', 'Lee', '123456789', '10 Jalan Bukit', 'alice.lee@company.com', NULL, TO_DATE('10/04/1990', 'DD/MM/YYYY'), 'D001');
INSERT INTO Staff (Staff_ID, Staff_FirstName, Staff_LastName, Staff_PhoneNum, Staff_Address, Staff_Email, Manager_ID, Staff_DOB, Department_ID) VALUES ('S002', 'Ben', 'Ng', '139876543', '22 Jalan Ampang', 'ben.ng@company.com', 'S001', TO_DATE('22/12/1988', 'DD/MM/YYYY'), 'D001');
INSERT INTO Staff (Staff_ID, Staff_FirstName, Staff_LastName, Staff_PhoneNum, Staff_Address, Staff_Email, Manager_ID, Staff_DOB, Department_ID) VALUES ('S003', 'Carol', 'Tan', '142233445', '33 Jalan Kuching', 'carol.tan@company.com', NULL, TO_DATE('18/05/1992', 'DD/MM/YYYY'), 'D002');
INSERT INTO Staff (Staff_ID, Staff_FirstName, Staff_LastName, Staff_PhoneNum, Staff_Address, Staff_Email, Manager_ID, Staff_DOB, Department_ID) VALUES ('S004', 'Daniel', 'Lim', '155566778', '12 Jalan Sultan', 'daniel.lim@company.com', 'S003', TO_DATE('09/07/1991', 'DD/MM/YYYY'), 'D002');
INSERT INTO Staff (Staff_ID, Staff_FirstName, Staff_LastName, Staff_PhoneNum, Staff_Address, Staff_Email, Manager_ID, Staff_DOB, Department_ID) VALUES ('S005', 'Eva', 'Wong', '112233445', '18 Jalan Ipoh', 'eva.wong@company.com', NULL, TO_DATE('15/01/1993', 'DD/MM/YYYY'), 'D003');
INSERT INTO Staff (Staff_ID, Staff_FirstName, Staff_LastName, Staff_PhoneNum, Staff_Address, Staff_Email, Manager_ID, Staff_DOB, Department_ID) VALUES ('S006', 'Farid', 'Rahman', '169988776', '25 Jalan Cheras', 'farid.rahman@company.com', 'S005', TO_DATE('03/11/1989', 'DD/MM/YYYY'), 'D003');
INSERT INTO Staff (Staff_ID, Staff_FirstName, Staff_LastName, Staff_PhoneNum, Staff_Address, Staff_Email, Manager_ID, Staff_DOB, Department_ID) VALUES ('S007', 'Grace', 'Teo', '176655443', '50 Jalan Tun Razak', 'grace.teo@company.com', NULL, TO_DATE('28/08/1994', 'DD/MM/YYYY'), 'D004');
INSERT INTO Staff (Staff_ID, Staff_FirstName, Staff_LastName, Staff_PhoneNum, Staff_Address, Staff_Email, Manager_ID, Staff_DOB, Department_ID) VALUES ('S008', 'Henry', 'Goh', '195544332', '28 Jalan Puduri', 'henry.goh@company.com', 'S007', TO_DATE('02/03/1990', 'DD/MM/YYYY'), 'D004');
INSERT INTO Staff (Staff_ID, Staff_FirstName, Staff_LastName, Staff_PhoneNum, Staff_Address, Staff_Email, Manager_ID, Staff_DOB, Department_ID) VALUES ('S009', 'Ivy', 'Koh', '128877665', '31 Jalan Imbi', 'ivy.koh@company.com', NULL, TO_DATE('21/06/1995', 'DD/MM/YYYY'), 'D005');
INSERT INTO Staff (Staff_ID, Staff_FirstName, Staff_LastName, Staff_PhoneNum, Staff_Address, Staff_Email, Manager_ID, Staff_DOB, Department_ID) VALUES ('S010', 'Jack', 'Yap', '183344552', '42 Jalan Sentul', 'jack.yap@company.com', 'S009', TO_DATE('19/09/1987', 'DD/MM/YYYY'), 'D005');
INSERT INTO Staff (Staff_ID, Staff_FirstName, Staff_LastName, Staff_PhoneNum, Staff_Address, Staff_Email, Manager_ID, Staff_DOB, Department_ID) VALUES ('S011', 'Ken', 'Tan', '145566778', '15 Jalan Raja Laut', 'ken.tan@company.com', NULL, TO_DATE('14/02/1990', 'DD/MM/YYYY'), 'D006');
INSERT INTO Staff (Staff_ID, Staff_FirstName, Staff_LastName, Staff_PhoneNum, Staff_Address, Staff_Email, Manager_ID, Staff_DOB, Department_ID) VALUES ('S012', 'Lily', 'Wong', '132233441', '60 Jalan Maluri', 'lily.wong@company.com', 'S011', TO_DATE('01/12/1991', 'DD/MM/YYYY'), 'D006');

--Insert records into Shift
INSERT INTO Shift (Shift_ID, Shift_Time, Shift_Date) VALUES ('SH001', '09:00-17:00', TO_DATE('7/1/2025', 'MM/DD/YYYY'));
INSERT INTO Shift (Shift_ID, Shift_Time, Shift_Date) VALUES ('SH002', '13:00-21:00', TO_DATE('7/1/2025', 'MM/DD/YYYY'));
INSERT INTO Shift (Shift_ID, Shift_Time, Shift_Date) VALUES ('SH003', '09:00-17:00', TO_DATE('7/2/2025', 'MM/DD/YYYY'));
INSERT INTO Shift (Shift_ID, Shift_Time, Shift_Date) VALUES ('SH004', '13:00-21:00', TO_DATE('7/2/2025', 'MM/DD/YYYY'));
INSERT INTO Shift (Shift_ID, Shift_Time, Shift_Date) VALUES ('SH005', '09:00-17:00', TO_DATE('7/3/2025', 'MM/DD/YYYY'));
INSERT INTO Shift (Shift_ID, Shift_Time, Shift_Date) VALUES ('SH006', '13:00-21:00', TO_DATE('7/3/2025', 'MM/DD/YYYY'));
INSERT INTO Shift (Shift_ID, Shift_Time, Shift_Date) VALUES ('SH007', '09:00-17:00', TO_DATE('7/4/2025', 'MM/DD/YYYY'));
INSERT INTO Shift (Shift_ID, Shift_Time, Shift_Date) VALUES ('SH008', '13:00-21:00', TO_DATE('7/4/2025', 'MM/DD/YYYY'));
INSERT INTO Shift (Shift_ID, Shift_Time, Shift_Date) VALUES ('SH009', '09:00-17:00', TO_DATE('7/5/2025', 'MM/DD/YYYY'));
INSERT INTO Shift (Shift_ID, Shift_Time, Shift_Date) VALUES ('SH010', '13:00-21:00', TO_DATE('7/5/2025', 'MM/DD/YYYY'));
INSERT INTO Shift (Shift_ID, Shift_Time, Shift_Date) VALUES ('SH011', '09:00-17:00', TO_DATE('7/6/2025', 'MM/DD/YYYY'));
INSERT INTO Shift (Shift_ID, Shift_Time, Shift_Date) VALUES ('SH012', '13:00-21:00', TO_DATE('7/6/2025', 'MM/DD/YYYY'));

--Insert records into Leave
INSERT INTO Leave (Leave_ID, Staff_ID, Leave_Reason, StartDate, EndDate, Status) VALUES ('L001', 'S003', 'Family emergency', TO_DATE('7/2/2025', 'MM/DD/YYYY'), TO_DATE('7/3/2025', 'MM/DD/YYYY'), 'Approved');
INSERT INTO Leave (Leave_ID, Staff_ID, Leave_Reason, StartDate, EndDate, Status) VALUES ('L002', 'S005', 'Medical leave', TO_DATE('7/5/2025', 'MM/DD/YYYY'), TO_DATE('7/6/2025', 'MM/DD/YYYY'), 'Approved');
INSERT INTO Leave (Leave_ID, Staff_ID, Leave_Reason, StartDate, EndDate, Status) VALUES ('L003', 'S007', 'Personal reason', TO_DATE('7/7/2025', 'MM/DD/YYYY'), TO_DATE('7/7/2025', 'MM/DD/YYYY'), 'Pending');
INSERT INTO Leave (Leave_ID, Staff_ID, Leave_Reason, StartDate, EndDate, Status) VALUES ('L004', 'S009', 'Annual leave', TO_DATE('7/8/2025', 'MM/DD/YYYY'), TO_DATE('7/10/2025', 'MM/DD/YYYY'), 'Approved');
INSERT INTO Leave (Leave_ID, Staff_ID, Leave_Reason, StartDate, EndDate, Status) VALUES ('L005', 'S002', 'Emergency leave', TO_DATE('7/4/2025', 'MM/DD/YYYY'), TO_DATE('7/4/2025', 'MM/DD/YYYY'), 'Approved');
INSERT INTO Leave (Leave_ID, Staff_ID, Leave_Reason, StartDate, EndDate, Status) VALUES ('L006', 'S004', 'Annual leave', TO_DATE('7/11/2025', 'MM/DD/YYYY'), TO_DATE('7/12/2025', 'MM/DD/YYYY'), 'Approved');
INSERT INTO Leave (Leave_ID, Staff_ID, Leave_Reason, StartDate, EndDate, Status) VALUES ('L007', 'S006', 'Sick leave', TO_DATE('7/9/2025', 'MM/DD/YYYY'), TO_DATE('7/10/2025', 'MM/DD/YYYY'), 'Rejected');
INSERT INTO Leave (Leave_ID, Staff_ID, Leave_Reason, StartDate, EndDate, Status) VALUES ('L008', 'S008', 'Marriage leave', TO_DATE('7/15/2025', 'MM/DD/YYYY'), TO_DATE('7/16/2025', 'MM/DD/YYYY'), 'Pending');
INSERT INTO Leave (Leave_ID, Staff_ID, Leave_Reason, StartDate, EndDate, Status) VALUES ('L009', 'S010', 'Family matter', TO_DATE('7/3/2025', 'MM/DD/YYYY'), TO_DATE('7/3/2025', 'MM/DD/YYYY'), 'Approved');
INSERT INTO Leave (Leave_ID, Staff_ID, Leave_Reason, StartDate, EndDate, Status) VALUES ('L010', 'S012', 'Medical leave', TO_DATE('7/13/2025', 'MM/DD/YYYY'), TO_DATE('7/14/2025', 'MM/DD/YYYY'), 'Approved');

--Insert records into Payroll
INSERT INTO Payroll (Payroll_ID, Staff_ID, Month, Year, Base_Salary, Overtime_Payment, Deduction) VALUES ('P001', 'S001', '7', 2025, 5000.00, 200.00, 50.00);
INSERT INTO Payroll (Payroll_ID, Staff_ID, Month, Year, Base_Salary, Overtime_Payment, Deduction) VALUES ('P002', 'S002', '7', 2025, 4500.00, 180.00, 0.00);
INSERT INTO Payroll (Payroll_ID, Staff_ID, Month, Year, Base_Salary, Overtime_Payment, Deduction) VALUES ('P003', 'S003', '7', 2025, 4000.00, 150.00, 100.00);
INSERT INTO Payroll (Payroll_ID, Staff_ID, Month, Year, Base_Salary, Overtime_Payment, Deduction) VALUES ('P004', 'S004', '7', 2025, 4000.00, 170.00, 50.00);
INSERT INTO Payroll (Payroll_ID, Staff_ID, Month, Year, Base_Salary, Overtime_Payment, Deduction) VALUES ('P005', 'S005', '7', 2025, 4200.00, 160.00, 0.00);
INSERT INTO Payroll (Payroll_ID, Staff_ID, Month, Year, Base_Salary, Overtime_Payment, Deduction) VALUES ('P006', 'S006', '7', 2025, 4300.00, 140.00, 20.00);
INSERT INTO Payroll (Payroll_ID, Staff_ID, Month, Year, Base_Salary, Overtime_Payment, Deduction) VALUES ('P007', 'S007', '7', 2025, 4100.00, 130.00, 0.00);
INSERT INTO Payroll (Payroll_ID, Staff_ID, Month, Year, Base_Salary, Overtime_Payment, Deduction) VALUES ('P008', 'S008', '7', 2025, 4200.00, 120.00, 0.00);
INSERT INTO Payroll (Payroll_ID, Staff_ID, Month, Year, Base_Salary, Overtime_Payment, Deduction) VALUES ('P009', 'S009', '7', 2025, 4150.00, 150.00, 0.00);
INSERT INTO Payroll (Payroll_ID, Staff_ID, Month, Year, Base_Salary, Overtime_Payment, Deduction) VALUES ('P010', 'S010', '7', 2025, 4300.00, 200.00, 50.00);
INSERT INTO Payroll (Payroll_ID, Staff_ID, Month, Year, Base_Salary, Overtime_Payment, Deduction) VALUES ('P011', 'S011', '7', 2025, 4050.00, 100.00, 0.00);
INSERT INTO Payroll (Payroll_ID, Staff_ID, Month, Year, Base_Salary, Overtime_Payment, Deduction) VALUES ('P012', 'S012', '7', 2025, 4150.00, 90.00, 0.00);

--Insert records into Attendance 

INSERT INTO Attendance (Attendance_ID, Staff_ID, Shift_ID, Attendance_Status, Extra_Time, Late_Reason) VALUES ('A001', 'S001', 'SH001', 'Present', 1.0, NULL);
INSERT INTO Attendance (Attendance_ID, Staff_ID, Shift_ID, Attendance_Status, Extra_Time, Late_Reason) VALUES ('A002', 'S002', 'SH001', 'Late', 0.5, 'Traffic jam'); 
INSERT INTO Attendance (Attendance_ID, Staff_ID, Shift_ID, Attendance_Status, Extra_Time, Late_Reason) VALUES ('A003', 'S003', 'SH001', 'Present', 0.0, NULL); 
INSERT INTO Attendance (Attendance_ID, Staff_ID, Shift_ID, Attendance_Status, Extra_Time, Late_Reason) VALUES ('A004', 'S004', 'SH002', 'Present', 1.5, NULL); 
INSERT INTO Attendance (Attendance_ID, Staff_ID, Shift_ID, Attendance_Status, Extra_Time, Late_Reason) VALUES ('A005', 'S005', 'SH002', 'Late', 0.0, 'Accident');
INSERT INTO Attendance (Attendance_ID, Staff_ID, Shift_ID, Attendance_Status, Extra_Time, Late_Reason) VALUES ('A006', 'S006', 'SH002', 'Present', 0.5, NULL);
INSERT INTO Attendance (Attendance_ID, Staff_ID, Shift_ID, Attendance_Status, Extra_Time, Late_Reason) VALUES ('A007', 'S007', 'SH003', 'Present', 0.0, NULL);
INSERT INTO Attendance (Attendance_ID, Staff_ID, Shift_ID, Attendance_Status, Extra_Time, Late_Reason) VALUES ('A008', 'S008', 'SH003', 'Late', 1.0, 'Bus breakdown');
INSERT INTO Attendance (Attendance_ID, Staff_ID, Shift_ID, Attendance_Status, Extra_Time, Late_Reason) VALUES ('A009', 'S009', 'SH003', 'Present', 0.5, NULL);
INSERT INTO Attendance (Attendance_ID, Staff_ID, Shift_ID, Attendance_Status, Extra_Time, Late_Reason) VALUES ('A010', 'S010', 'SH004', 'Present', 2.0, NULL);
INSERT INTO Attendance (Attendance_ID, Staff_ID, Shift_ID, Attendance_Status, Extra_Time, Late_Reason) VALUES ('A011', 'S011', 'SH004', 'Late', 0.0, 'Family emergency');
INSERT INTO Attendance (Attendance_ID, Staff_ID, Shift_ID, Attendance_Status, Extra_Time, Late_Reason) VALUES ('A012', 'S012', 'SH004', 'Present', 0.5, NULL); 


