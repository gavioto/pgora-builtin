\set ECHO all

/* Register alerts */
SELECT dbms_alert.register('a1');
SELECT dbms_alert.register('a2');
SELECT dbms_alert.register('tds');

/* Test: multisession waitone */
SELECT dbms_alert.waitone('a1',10);

/* Test: multisession waitany */
SELECT dbms_alert.waitany(2);

/* Test defered_signal */
/* This indicated that the transaction has begun */
SELECT dbms_alert.waitone('tds',2);
/* The signal will not be received because the transaction is running */
SELECT dbms_alert.waitone('tds',2);
SELECT dbms_alert.signal('b1','Transaction still running');
SELECT dbms_alert.signal('b1','Transaction committed');
/* Since the transaction has commited, the signal will be received */
SELECT dbms_alert.waitone('tds',2);

/* Signal session A to send msg1 for a3 */
SELECT dbms_alert.signal('b2','to check unregistered alert wait');
/* Test: wait for unregistered alert which is signaled*/
SELECT dbms_alert.waitone('a3',2);

/* Test: Register after alert is signaled and wait */
SELECT dbms_alert.register('a4');
SELECT dbms_alert.waitone('a4',2);

/* Test: remove one */
SELECT dbms_alert.remove('a1');
/* Signal session A to send msg2 for a1 */
SELECT dbms_alert.signal('b3','remove(a1) called');
/* Test: wait for removed alert */
SELECT dbms_alert.waitone('a1',2);
/* Signal session A to send msg1 for a4 */
SELECT dbms_alert.signal('b4','to check unremoved alert');
/* Test: Check if unremoved alert is received */
SELECT dbms_alert.waitone('a4',2);

/* Test removeall */
SELECT dbms_alert.removeall();
/* Signal session A to send msg2 for a2 */
SELECT dbms_alert.signal('b5','removeall called');
/* Test: Use waitany to see if any alert is received */
SELECT dbms_alert.waitany(2);