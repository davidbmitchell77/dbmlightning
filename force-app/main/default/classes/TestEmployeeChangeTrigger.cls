@isTest
public class TestEmployeeChangeTrigger {
    @isTest static void testCreateAndUpdateEmployee() {
        // Enable all Change Data Capture entities for notifications.
        Test.enableChangeDataCapture();
        // Insert an Employee test record
        insert new Employee2__c(Name='e-101',
            FirstName__c='Astro',
            LastName__c='Test',
            Tenure__c=1);
        // Call deliver to fire the trigger and deliver the test change event.
        Test.getEventBus().deliver();
        // VERIFICATIONS
        // Check that the change event trigger created a task.
        Task[] taskList = [SELECT Id,Subject FROM Task];
        System.assertEquals(1, taskList.size(),
            'The change event trigger did not create the expected task.');
        // Update employee record
        Employee2__c[] empRecords = [SELECT Id,OwnerId,FirstName__c,Tenure__c FROM Employee2__c];
        // There is only one test record, so get the first one
        Employee2__c emp = empRecords[0];
        // Debug
        System.debug('Retrieved employee record: ' + emp);
        // Update one field and empty another
        emp.FirstName__c = 'Codey';
        emp.Tenure__c = null;
        update emp;
        // Call deliver to fire the trigger for the update operation.
        Test.getEventBus().deliver();
        // VERIFICATIONS
       // Check that the change event trigger created a task.
       // We should have two tasks now, including one from the first trigger invocation.
      Task[] taskList2 = [SELECT Id,Subject FROM Task];
      System.assertEquals(2, taskList2.size(),
          'The change event trigger did not create the expected task.');
    }
}