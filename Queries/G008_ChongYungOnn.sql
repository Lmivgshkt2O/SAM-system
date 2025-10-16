/*
Format: G008_ChongYungOnn.sql

INDIVIDUAL ASSIGNMENT SUBMISSION

STUDENT NAME : Chong Yung Onn
STUDENT ID : 24ACB01515
GROUP NUMBER : G008
PROGRAMME : IA
Submission date and time: 09-09-25

SQL script to be submtted by each member, click save as "G999_MemberName.sql" e.g. G001_SmithWhite.sql

*/



/* Query 1 -- List all scheduled staff for a specific day*/

SELECT 
    s.Staff_ID,
    s.Staff_FirstName,
    s.Staff_LastName,
    sh.Shift_ID,
    sh.Shift_Time,
    sh.Shift_Date,
    d.Department_Name
FROM Staff s
JOIN Attendance a ON s.Staff_ID = a.Staff_ID
JOIN Shift sh ON a.Shift_ID = sh.Shift_ID
JOIN Department d ON s.Department_ID = d.Department_ID
WHERE sh.Shift_Date = TO_DATE('7/1/2025', 'MM/DD/YYYY')
ORDER BY sh.Shift_Time, s.Staff_LastName;



/* Query 2 -- Show staff attendance history*/

SELECT 
    s.Staff_ID,
    s.Staff_FirstName || ' ' || s.Staff_LastName AS Staff_Name,
    sh.Shift_Date,
    sh.Shift_Time,
    a.Attendance_Status,
    a.Extra_Time,
    a.Late_Reason,
    d.Department_Name
FROM Attendance a
JOIN Staff s ON a.Staff_ID = s.Staff_ID
JOIN Shift sh ON a.Shift_ID = sh.Shift_ID
JOIN Department d ON s.Department_ID = d.Department_ID
WHERE s.Staff_ID = 'S001' -- Replace with specific staff ID
ORDER BY sh.Shift_Date DESC;



/* Stored procedure 1 -- Insert attendance record */
CREATE OR REPLACE PROCEDURE insert_attendance (
    p_attendance_id     IN VARCHAR2,
    p_staff_id          IN VARCHAR2,
    p_shift_id          IN VARCHAR2,
    p_attendance_status IN VARCHAR2,
    p_extra_time        IN NUMBER DEFAULT 0,
    p_late_reason       IN VARCHAR2 DEFAULT NULL
) AS
    invalid_status_exp EXCEPTION;
    invalid_time_exp   EXCEPTION;
    v_final_late_reason VARCHAR2(100);
BEGIN
    -- Validate attendance status
    IF p_attendance_status NOT IN ('Present', 'Late', 'Absent') THEN
        RAISE invalid_status_exp;
    END IF;

    -- Validate extra time
    IF p_extra_time < 0 THEN
        RAISE invalid_time_exp;
    END IF;

    -- Set late reason only if status is 'Late'
    IF p_attendance_status = 'Late' THEN
        v_final_late_reason := NVL(p_late_reason, 'Not specified');
    ELSE
        v_final_late_reason := NULL;
    END IF;

    -- Insert record
    INSERT INTO Attendance (
        Attendance_ID, 
        Staff_ID, 
        Shift_ID, 
        Attendance_Status, 
        Extra_Time, 
        Late_Reason
    ) VALUES (
        p_attendance_id,
        p_staff_id,
        p_shift_id,
        p_attendance_status,
        p_extra_time,
        v_final_late_reason
    );
    DBMS_OUTPUT.PUT_LINE('SUCCESS: Attendance record inserted for Staff ID: ' || p_staff_id);

EXCEPTION
    WHEN invalid_status_exp THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: Invalid attendance status. Must be Present, Late, or Absent.');
    WHEN invalid_time_exp THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: Invalid extra time. Must be greater than or equal to zero.');
END insert_attendance;
/



/* Stored procedure 2 -- Update attendance status */
CREATE OR REPLACE PROCEDURE update_attendance_status (
    p_attendance_id     IN VARCHAR2,
    p_attendance_status IN VARCHAR2,
    p_late_reason       IN VARCHAR2 DEFAULT NULL,
    p_extra_time        IN NUMBER DEFAULT NULL
) AS
    v_old_status VARCHAR2(15);

    -- User-defined exceptions
    record_not_found_exp EXCEPTION;
    invalid_status_exp   EXCEPTION;
    invalid_time_exp   EXCEPTION;

BEGIN
    -- Check if the record exists and fetch current status
    SELECT Attendance_Status 
    INTO v_old_status
    FROM Attendance 
    WHERE Attendance_ID = p_attendance_id;

    -- Validate new status
    IF p_attendance_status NOT IN ('Present', 'Late', 'Absent') THEN
        RAISE invalid_status_exp;
    END IF;
    
    IF p_extra_time < 0 THEN
        RAISE invalid_time_exp;
    END IF;

    -- Perform update
    UPDATE Attendance 
    SET 
        Attendance_Status = p_attendance_status,
        Late_Reason = CASE 
            WHEN p_attendance_status = 'Late' THEN NVL(p_late_reason, 'Not specified')
            ELSE NULL
        END,
        Extra_Time = NVL(p_extra_time, Extra_Time)
    WHERE Attendance_ID = p_attendance_id;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('SUCCESS: Attendance ID "' || p_attendance_id ||'" updated from "' || v_old_status || '" to "' ||p_attendance_status || '".');

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: Attendance ID "' || p_attendance_id || '" not found.');
        ROLLBACK;
    WHEN invalid_status_exp THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: Invalid attendance status. Must be Present, Late, or Absent.');
        ROLLBACK;
    WHEN invalid_time_exp THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: Invalid extra time. Must be greater than or equal to zero.');

END update_attendance_status;
/



/* Function 1-- calculate overtime hours for a staff member */
CREATE OR REPLACE FUNCTION Get_Total_Extra_Time (
    p_staff_id IN VARCHAR2
) RETURN NUMBER
AS
    v_total_time NUMBER := 0;
    v_staff_exists NUMBER;

    staff_not_found EXCEPTION;
BEGIN
    -- Check if staff exists
    SELECT COUNT(*) INTO v_staff_exists
    FROM Staff
    WHERE Staff_ID = p_staff_id;

    IF v_staff_exists = 0 THEN
        RAISE staff_not_found;
    END IF;

    -- Calculate total extra time
    SELECT NVL(SUM(Extra_Time), 0)
    INTO v_total_time
    FROM Attendance
    WHERE Staff_ID = p_staff_id;

    RETURN v_total_time;

EXCEPTION
    WHEN staff_not_found THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: Staff ID "' || p_staff_id || '" not found.');
        RETURN -1;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
        RETURN -1;
END Get_Total_Extra_Time;
/


/* Function 2 -- Check if the staff late on specific date */
CREATE OR REPLACE FUNCTION Is_Staff_Late(
    p_Staff_ID IN VARCHAR2,
    p_Date IN DATE
) RETURN VARCHAR2 IS
    status VARCHAR2(15);
BEGIN
    SELECT Attendance_Status
    INTO status
    FROM Attendance a
    JOIN Shift s ON a.Shift_ID = s.Shift_ID
    WHERE a.Staff_ID = p_Staff_ID AND s.Shift_Date = p_Date;

    RETURN status;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'No Record';
END;
/
