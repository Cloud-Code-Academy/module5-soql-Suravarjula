/**
* The SOQL class serves as a primer into the Salesforce Object Query Language in Apex.
* It covers fundamental aspects such as SELECT statements, WHERE clauses, Relationship queries, and LIMIT keyword.
*
* This class introduces developers to the concept of retrieving data from Salesforce using SOQL. It provides
* a step-by-step guide on how to construct SOQL queries, filter results using WHERE clause, retrieve related
* records, and manage data volume using the LIMIT keyword.
* 
* Topics covered in this class include:
* - Understanding the structure of a SOQL query.
* - Crafting basic SELECT statements in SOQL.
* - Applying filters using the WHERE clause in SOQL.
* - Fetching related records using Relationship queries.
* - Controlling the amount of data retrieved using the LIMIT keyword.
* 
* Users of this class can expect to gain a solid understanding of SOQL in Apex and
* be prepared to handle data retrieval tasks in Salesforce development.
* 
* @author Nagesh Kumar Suravarjula
*/

public with sharing class SOQL {
    
    /**
     * Question 1
     * Update/Uncomment the template code to create a method
     * Returns all leads from Salesforce Org
     * @return List of all leads with Id, LastName, Company, Phone, Email
     * Update the corresponding test class and testGetAllLeads method to cover this method
     */
    public  static List<Lead> getAllLeads () {
    //  The body of the method
        List<Lead> allLeads = [SELECT Id, LastName, Company, Phone, Email from Lead where createdDate = TODAY];
        return allLeads;
    }

    /**
     * Question 2
     * Update/Uncomment the template code to create a method
     * Returns all contacts with first name of John.
     * @return A list of Contact records.
     * Update the corresponding test class and testGetContactsByFirstName method to cover this method
     */
    public static List<Contact> getContactsByFirstName(String firstName) {
    //  The body of the method
    //    List<Contact> matchingContacts = [SELECT Id, FirstName, LastName, Name from Contact where FirstName = 'John'];

        /* I would like understand what is the drawback of returning the list of Contact records as below instead of first creating the List 
                and then returning the List variable.  
           Are we going to hit any governor limits or will it throw any exception if the Select statement doesn't find any records to be returned ? */

        return [SELECT Id, FirstName, LastName, Name from Contact where FirstName = :firstName]; 
    }

    /**
     * Question 3
     * Update/Uncomment the template code to create a method
     * Returns the Contact Id for all contacts with last name of Smith or Jones
     * @return A list of Contact Ids.
     * Update the corresponding test class and testGetContactIdsByLastName method to cover this method
     */
    public static List<Id>  getContactIdsByLastName(List<String> lastNames) {
    //  The body of the method
        List<Contact> contactsWithLastName = [SELECT Id from Contact where LastName in :lastNames];
        List<Id> contactIds = new List<Id>();
        for (Contact contact : contactsWithLastName) {
            contactIds.add(contact.Id);
        }
        return contactIds;
    }

    /**
     * Question 4
     * Update/Uncomment the template code to create a method
     * Returns List of closed won opportunities for a specific Account.
     * Example: yourMethodName('001XXXXXXXXXXXX') should return the list of closed won opportunities for the Account with the Id
     * @param accountId The ID of the Account.
     * @return A list of Opportunities with important opportunities fields
     * Update the corresponding test class and testGetClosedWonOpportunityCountByAccount method to cover this method
     */
    public static List<Opportunity> getClosedWonOpportunityCountByAccount(Id accountId) {
    //  The body of the method
        List<Opportunity> accountOpportunities = [SELECT Id, Name, Description, Amount, StageName, AccountId, CloseDate from Opportunity where AccountId = :accountId and StageName = 'Closed Won'];
        return accountOpportunities;
    }

    /**
     * Question 5
     * Update/Uncomment the template code to create a method
     * Returns the total count of Account records.
     * @return The Integer count of Account records.
     * Update the corresponding test class and testGetAccountCount method to cover this method
     */
    public static Integer getAccountCount () {
    //  The body of the method
        return [SELECT Id from Account where CreatedDate = TODAY].size();
    }

    /**
     * Question 6
     * Update/Uncomment the template code to create a method
     * Return Key Value pair of Task Id and Task records for any tasks due date within the next 7 days.
     * @return A map of Task Ids to Task records.
     * Update the corresponding test class and testGetTasksDueNextWeek method to cover this method
     */
    public static Map<Id,Task> getTasksDueNextWeek () {
    //  The body of the method
        List<Task> allTasksDueIn7Days = [SELECT Id, WhatId, Subject, ActivityDate, Status, Priority, OwnerId, AccountId, isClosed FROM Task where ActivityDate > TODAY and  ActivityDate <= NEXT_N_DAYS:7];
        Map<Id, Task> tasksMap = new Map<Id, Task>();

        for (Task taskRec : allTasksDueIn7Days) {
            tasksMap.put(taskRec.Id, taskRec);
        }

        return tasksMap;
    }

    /**
     * Question 7
     * Update/Uncomment the template code to create a method
     * Retrieves all Contacts that have a example.com domain in their Email.
     * @return A list of Contact records.
     * Update the corresponding test class and testGetContactsByEmailDomain method to cover this method
     */
    public static List<Contact> getContactsByEmailDomain () {
    //  The body of the method
        return [SELECT Id, Name, Email from Contact where email like '%example.com'];
    }

    /**
     * Question 8
     * Retrieves all Opportunities that have a specific keyword in their Name.
     * Example: getOpportunitiesByNameKeyword('keyword') should return all Opportunities that have 'keyword' in their Name.
     * @param keyword The keyword to search for in the Opportunity Name.
     * @return A list of Opportunity records.
     */
    public static List<Opportunity> getOpportunitiesByNameKeyword(String keyword) {
        return Database.query('SELECT Id, Name, Description, Amount from Opportunity where Name like \'%' +  keyword + '%\''); // Replace null with the variable you used to store the result
    }

    /**
     * Question 9
     * Retrieves all Cases that Case Origin is not Web or Email or Blank
     * @return A list of Case records.
     */
    public static List<Case> getFilterCaseOrigins() {
        return [SELECT Id, Subject, Description, Origin from Case where Origin NOT IN ('Web', 'Email', '')]; // Replace null with the variable you used to store the result
    }

    /**
     * Question 10
     * Update/Uncomment the template code to create a method
     * Retrieves all Leads that have a specific Lead Source or contain a specific keyword in their Title.
     * Example: yourMethodName('Web', 'Engineer') should return all Leads that have 'Web' in their Lead Source or 'Engineer' in their Title.
     * @param leadSource The Lead Source to search for.
     * @param keyword The keyword to search for in the Lead Title.
     * @return A list of Lead records.
     * Update the corresponding test class and testGetLeadsBySourceOrTitle method to cover this method
     */
    public static List<Lead> getLeadsBySourceOrTitle (String paramLeadSource, String paramTitle) {
    //  The body of the method
        return Database.query('SELECT Id, FirstName, LastName, Title, Company, Phone, Email, LeadSource, Status FROM Lead where LeadSource like \'%' + paramLeadSource + '%\'' + ' OR Title like \'%' + paramTitle + '%\'');
    }    

    /**
     * Question 11
     * Returns the names of all Contacts associated with an Account.
     * Example: getContactNamesByAccount('001XXXXXXXXXXXX') should return the list of Contact LastNames for the Account with the Id
     * @param accountId The ID of the Account.
     * @return A list of Contact LastName.
     */
    public static List<String> getContactNamesByAccount(Id accountId) {
        // Create a list to hold the Contact LastNames
        List<String> contactLastNames = new List<String>();

        // Query the Contacts
        // Loop through each Contact and add the LastName to the list
        for (Contact contactRecord : [SELECT Id, FirstName, LastName, Email, AccountId from Contact where AccountId = :accountId]) {
            contactLastNames.add(contactRecord.LastName);
        }

        // Return the list of Contact LastNames
        return contactLastNames; // Replace null with the variable you used to store the result
    }

    /**
     * Question 12
     * Returns the total revenue for all Opportunities in a specific Stage or if the amount is greater than 10000.
     * Example: getTotalRevenueByStage('Closed Won') should return the total revenue for all Opportunities in the 'Closed Won' Stage.
     * @param stage The Stage value to filter Opportunities.
     * @return The total revenue.
     */
    public static Decimal getTotalRevenueByStage(String stage) {
        // Use AggregateQuery to get the total revenue
        AggregateResult[] aggResult = [SELECT SUM(Amount) from Opportunity where StageName = :stage or Amount >= 10000];

        // Return the total revenue
        return Decimal.valueOf(aggResult[0].get('expr0').toString()); // Replace null with the variable you used to store the result
    }

    /**
     * Question 13
     * Retrieves the first 10 Accounts ordered by Name.
     * @return A list of the first 10 Accounts ordered by Name.
     */
    public static List<Account> getFirstTenAccounts() {
        return [SELECT Id, Name from Account Order By Name limit 10]; // Replace null with the variable you used to store the result
    }
    
    /**
     * Question 14
     * Retrieves the Opportunities with an Amount greater than 100,000, ordered by CloseDate, and limited to 5 records.
     * @return A list of Opportunities with an Amount greater than 100,000, ordered by CloseDate, and limited to 5 records.
     */
    public static List<Opportunity> getHighValueOpportunities() {
        return [SELECT Id, Name, Amount, CloseDate from Opportunity where Amount > 100000 Order By CloseDate limit 5]; // Replace null with the variable you used to store the result
    }
    
    /**
     * Question 15
     * Retrieves the Contacts with the most recent Birthdate, ordered by Birthdate, and limited to 3 records.
     * @return A list of Contacts
     */
    public static List<Contact> getBirthdateContacts() {
        return [SELECT Id, FirstName, LastName, Account.Name, BirthDate from Contact where BirthDate != null Order by BirthDate Desc LIMIT 3]; // Replace null with the variable you used to store the result
    }
    
    /**
     * Question 16
     * Retrieves the Cases in the Open Status, ordered by CreatedDate, and limited to 10 records with an offset of 5.
     * @return A list of Cases
     */
    public static List<Case> getCasesWithStatus() {
        return [SELECT Id, Subject, Description, Status, CreatedDate from Case where Status = 'Open' Order By CreatedDate LIMIT 10 OFFSET 5]; // Replace null with the variable you used to store the result
    }

    /**
     * Question 17
     * Returns Set of Case Ids for a specific Account.
     * Example: getCaseIdsByAccount('001XXXXXXXXXXXX') should return the set of Case Ids for the Account with the Id
     * @param accountId The ID of the Account.
     * @return A set of Case Ids.
     */
    public static Set<Id> getCaseIdsByAccount(Id accountId) {
        // Create a set to hold the Case Ids
        Set<Id> caseIds = new Set<Id>();

        // Query the Cases
        // Loop through each Case and add the Id to the set
        for (Case caseRecord : [SELECT Id from Case where AccountId = :accountId]) {
            caseIds.add(caseRecord.Id);    
        }

        return caseIds; // Replace null with the variable you used to store the result
    }

    /**
     * Question 18
     * Return Map of Account Ids to Account Names Not in a specific Country.
     * Example: getAccountIdsToNamesNotInCountry('United States') should return the map of Account Ids to Account Names for Accounts that are not in the United States.
     * @param country The country to filter Accounts.
     * @return A map of Account Ids to Account Names.
     */
    public static Map<Id, String> getAccountIdsToNamesNotInCountry(String country) {
        // Create a map to hold the Account Ids to Account Names
        Map<Id, String> accountIdsToNames = new Map<Id, String>();

        // Query the Accounts
        // Loop through each Account and add the Id and Name to the map
        for (Account acctRecord : [SELECT Id, Name from Account where BillingCountry != :country]){
            accountIdsToNames.put(acctRecord.Id, acctRecord.Name);
        }

        return accountIdsToNames; // Replace null with the variable you used to store the result
    }

    /**
     * Question 19
     * Retrieves the Account Name for a given Contact.
     * Example: getAccountNameForContact('003XXXXXXXXXXXX') should return the Account Name for the Contact with the Id
     * @param contactId The Id of the Contact.
     * @return The Account Name of the Contact.
     */
    public static String getAccountNameForContact(String contactId) {
        return [SELECT Account.Name, Name from Contact where Id = :contactId].get(0).Account.Name; // Replace null with the variable you used to store the result
    }    

    /**
     * Question 20
     * Returns single Account that has related opportunities in the same query
     * Example: getOpportunityAndAccountNamesForLineItem('001XXXXXXXXXXXX') should return the Account Name for the Account with the Id and all related Opportunities
     * @param accountId The ID of the Account.
     * @return An Account record with related Opportunities.
     */
    public static Account getOpportunityAndAccountNamesForLineItem(Id accountId) {
        return [SELECT Id, Name, (select Name, Amount, StageName from Opportunities) from Account where Id = :accountId]; // Replace null with the variable you used to store the result
    }

    /**
     * Question 21
     * Retrieves all contacts that have the Mailing State similar to the Account Billing State.
     * Example: getAccountsWithContactsByState('001XXXXXXXXXXXX') should return a list of Contacts that have the same Mailing State as the Account with the Id
     * @param Account Id
     * @return List of contacts with the same Mailing State as the Account Billing State
     */
    public static List<Contact> getAccountsWithContactsByState(Id accountId) {
        // Query the Account
        Account accountRecord = [SELECT Id, Name, BillingState from Account where Id = :accountId].get(0);
        // Store the Account's BillingState
        // Query the Contacts
        return [SELECT Id, FirstName, LastName, MailingAddress from Contact where MailingState = :accountRecord.BillingState]; // Replace null with the variable you used to store the result
    }

    /**
     * Question 22
     * Extracts email domains from them leads, then finds Accounts with matching website domains
     * If Lead Email = test@test.com return account with website = www.test.com
     * Example: findContactsByLeadEmailDomains([set of lead ids]) should return a list of Accounts with matching email domains
     * @param A set of Lead Ids.
     * @return A list of Accounts with matching email domains.
     */
    public static List<Account> findContactsByLeadEmailDomains(Set<Id> leadIds) {
        // Query the Leads
        List<Lead> leadList = [SELECT Id, Email from Lead where Id in :leadIds];

        // Create a set of email domains from the Leads
        Set<String> leadEmailDomains = new Set<String>();

        // Loop through each Lead
        for (Lead lead : leadList) {
            // Get the email from the Lead
            // Check if the email is not null
            // Add the email domain to the set
            if(!String.isBlank(lead.Email)) {
                leadEmailDomains.add('%' + lead.Email.subStringAfter('@') + '%');
            }
        }

        // Query the Accounts
        return [SELECT Id, Name, Website from Account where Website like :leadEmailDomains]; // Replace null with the variable you used to store the result
    }

    /**
     * Question 23
     * Clones and Inserts Opportunity Line Items from an original Opportunity to a list of cloned Opportunities.
     * Adds a randomized number between 1 to 3 to the quantity of each line item.
     * Example: cloneLineItems('001XXXXXXXXXXXX', [list of opportunity ids]) should clone the line items from the Opportunity with the Id to each Opportunity in the list
     * @param Original Opportunity Id
     * @param List of cloned Opportunity Ids
     */
    public static void cloneLineItems(Id origOppId, List<Id> cloneOppIds) {
        // Query the original Opportunity Line Items
        List<OpportunityLineItem> oppLineItems = [SELECT Id, OpportunityId, PricebookEntryId, ProductCode, Name, Quantity, TotalPrice, UnitPrice, ListPrice from OpportunityLineItem where OpportunityId = :origOppId];

        // Create a list to hold the new line items
        List<OpportunityLineItem> cloneOppLineItems;
        
        // Generate a random number between 1 and 3
        Integer randomNumber = (Integer)Math.floor(Math.random() * 10) + 3;
        // Loop through each cloned Opportunity Id
        for(Id cloneOppId : cloneOppIds) {
            cloneOppLineItems = new List<OpportunityLineItem>();
            // Loop through each original line item
            for(OpportunityLineItem oppLineItem : oppLineItems) {
                // Clone the original line item and add the random number to the quantity
                cloneOppLineItems.add(new OpportunityLineItem(OpportunityId = cloneOppId, PricebookEntryId = oppLineItem.PricebookEntryId, Quantity = randomNumber, UnitPrice = oppLineItem.UnitPrice));
            }

            // Insert the new line items
            insert cloneOppLineItems;
        }
    }
    
    /**
     * Question 24
     * Retrieves the Opportunity Name, Account Name, and Owner Name for Opportunities that have a Stage of 'Closed Won'.
     * Example: getOpportunityDetailsForClosedWon()
     * @return A list of filtered Opportunity
     */
    public static List<Opportunity> getOpportunityDetailsForClosedWon() {        
        return [SELECT Id, Name, AccountId, Account.Name, OwnerId, Primary_Contact__c from Opportunity where StageName = 'Closed Won']; // Replace null with the variable you used to store the result
    }

    /**
     * Question 25
     * Sets the 'Primary_Contact__c' field for all Closed Won Opportunities to first Contact on the Account.
     * Example: setPrimaryContact() should set the 'Primary_Contact__c' field for every Opportunity in the org
     */
    public static void setPrimaryContact() {
        //Use the getOpportunityDetailsForClosedWon() method to get the Opportunities
        List<Opportunity> closedOpportunityList = getOpportunityDetailsForClosedWon();
        // Create a set of Account Ids from the Opportunities
        Set<Id> accountIdList = new Set<Id>();
        for(Opportunity oppRec : closedOpportunityList){
            accountIdList.add(oppRec.AccountId);
        }

        // Query the Contacts
        List<Contact> contactList = [SELECT Id, AccountId from Contact where AccountId IN :accountIdList];
        Map<Id, Id> accountContactMap = new Map<Id, Id>();
        // Loop through each Contact and add the Account Id and Contact to the map
        for(Contact contactRec : contactList) {
            accountContactMap.put(contactRec.AccountId, contactRec.Id);
        }
        
        // Loop through each Opportunity
        for(Opportunity closedOppRec : closedOpportunityList) {
                // Update the Opportunity primary contact from accountToContactMap
                closedOppRec.Primary_Contact__c = accountContactMap.get(closedOppRec.AccountId);
        }

        // Update the Opportunities
        upsert closedOpportunityList;
    }
}