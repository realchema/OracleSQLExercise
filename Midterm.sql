SPOOL C:\MidTerm.txt


connect sys/sys as sysdba
connect jose17/001

SET SERVEROUTPUT ON

--------------------------------------------


CREATE OR REPLACE FUNCTION qst (p_num IN NUMBER)
                  RETURN NUMBER AS
  v_num NUMBER := p_num;
  v_result  NUMBER;
BEGIN
  v_result := v_num * 9.98/100;
  RETURN v_result;
END;
/

CREATE OR REPLACE FUNCTION gst (p_num IN NUMBER)
                  RETURN NUMBER AS
  v_num NUMBER := p_num;
  v_result  NUMBER;
BEGIN
  v_result := v_num * 5/100;
  RETURN v_result;
END;
/

CREATE OR REPLACE PROCEDURE Q1 (p_num IN NUMBER) AS
    v_num NUMBER := p_num;
    v_gst NUMBER;
    v_qst NUMBER;
    v_total NUMBER;
    v_grand_total NUMBER;
  BEGIN
   
     v_qst := qst(v_num);
   v_gst := gst(v_num); 
    v_total := v_gst + v_qst;
    v_grand_total := v_num + v_total;

DBMS_OUTPUT.PUT_LINE( 'For a price of $' || v_num || 'You have to pay $' || v_gst || ' GST and $' || v_qst || ' QST ');
 
DBMS_OUTPUT.PUT_LINE( 'The total tax is $' || v_total);
DBMS_OUTPUT.PUT_LINE( 'The grand total is $' || v_grand_total);
END;
/

EXEC Q1(30) 

---------------------------------------------------------------------


CREATE OR REPLACE FUNCTION if_even (p_1 NUMBER) RETURN NUMBER AS
    v_result NUMBER;
   BEGIN
      IF MOD(p_1,2) = 0 THEN
      v_result := 1;
      END IF;
      
      RETURN v_result ;
        END;
  /
  
    CREATE OR REPLACE PROCEDURE Q2 (P1 number, p2 NUMBER) as
    BEGIN
      IF p1 < p2 THEN
      IF if_even(p1) = 1 AND if_even(p2) = 1 THEN
                    DBMS_OUTPUT.PUT_LINE(p1 || ' and ' || p2 || ' are even ');

                    END IF;
          FOR even_idx IN p1+1 .. p2-1 LOOP
             IF if_even(even_idx)  = 1 THEN
                DBMS_OUTPUT.PUT_LINE(even_idx);
             END IF;
          END LOOP;
      ELSIF p1 > p2 THEN
      IF if_even(p1) = 1 AND if_even(p2) = 1 THEN
                    DBMS_OUTPUT.PUT_LINE(p1 || ' and ' || p2 || ' are even ');

                    END IF;
          FOR even_idx IN p2+1 .. p1-1 LOOP
             IF if_even(even_idx) = 1 THEN
                DBMS_OUTPUT.PUT_LINE(even_idx);
                
             END IF;
          END LOOP;
        
      END IF;
    END;
    /
    
    EXEC Q2(40,20)
    --------------------------------------------------------------
    
    CREATE OR REPLACE PROCEDURE Q3 (p_o_id orders.o_id%TYPE) AS
  v_o_id  orders.o_id%TYPE;
  v_o_date orders.o_date%TYPE;
  v_days NUMBER;

BEGIN
  SELECT o_id, o_date
  INTO   v_o_id, v_o_date
  FROM   orders
  WHERE  o_id = p_o_id;
    
    v_days := TRUNC(sysdate - v_o_date);

 DBMS_OUTPUT.PUT_LINE('Order number '  || v_o_id || ' is placed on  ' || v_o_date || ' .It has been  ' || v_days ||' days since ');

EXCEPTION
   WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE(' Order id   ' || p_o_id || 
                            ' does not exist MY FRIEND!' );
END;
/

EXEC Q3(1)

---------------------------------------------

CREATE OR REPLACE PROCEDURE Q4 (p_inv_id inventory.inv_id%TYPE) AS
 
 
 
 v_inv_qoh inventory.inv_qoh%TYPE;

  v_comment VARCHAR2(100) ;

BEGIN

  SELECT inv_qoh
  INTO   v_inv_qoh 
  FROM   inventory 
  WHERE  inv_id = p_inv_id;

   IF v_inv_qoh > 100 THEN
      v_comment := 'Excellent';
   ELSIF v_inv_qoh > 50 AND v_inv_qoh < 99 THEN
      v_comment := 'Very Good';
   ELSIF v_inv_qoh > 10 AND v_inv_qoh < 49 THEN
      v_comment := 'Good';
  ELSIF v_inv_qoh > 2 AND v_inv_qoh < 9 THEN
      v_comment := 'AVERAGE';
   ELSIF v_inv_qoh < 2 THEN
      v_comment := 'Provide Discount';
   END IF;

  DBMS_OUTPUT.PUT_LINE(v_comment );
  
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE(' inventory id   ' || p_inv_id || 
                            ' does not exist MY FRIEND!' );

END;
/

EXEC Q4(3)
---------------------------------------------------------------
CREATE OR REPLACE PROCEDURE Q5 (p_oid orders.o_id%TYPE,p_o_date DATE, p_o_methPMT NUMBER,
                p_os_id order_source.os_id%Type, p_c_id customer.c_id%Type) AS
  v_os_desc order_source.os_desc%TYPE;
  v_c_last  customer.c_last%TYPE;
  v_c_first customer.c_first%Type;
  
  flag NUMBER := 2;
BEGIN
  flag := 1;
  SELECT c_last, c_first
  INTO   v_c_last, v_c_first
  FROM   customer,orders
  WHERE  customer.c_id = orders.c_id;
  
  
  flag := 2;
  SELECT os_desc
  INTO   v_os_desc
  FROM   order_source, orders
  WHERE  order_source.os_id = orders.os_id;
  
  DBMS_OUTPUT.PUT_LINE(' order source id AND customer id ARE OK ');


   INSERT INTO orders
   VALUES(p_oid, p_o_date , p_o_methPMT, p_os_id, p_c_id);
   COMMIT;


  DBMS_OUTPUT.PUT_LINE(p_c_id ||' LAST =   ' || v_c_last || 
' FIRST = ' || v_c_first ||
' orders source description = ' || v_os_desc );




  
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    IF flag = 1 THEN
    DBMS_OUTPUT.PUT_LINE(' Customer id  ' || p_c_id || 
                            ' does not exist MY FRIEND!' );
    ELSIF flag = 2 THEN
    DBMS_OUTPUT.PUT_LINE(' oreder source ID  ' || p_os_id || 
                            ' does not exist MY FRIEND!' );
    END IF;
END;
/

SPOOL OFF
