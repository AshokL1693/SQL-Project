-- ASSESSMENT EXAM --

/* 1.How can you retrieve all the info from the cd.facilities table? */
     SELECT * FROM cd.facilities;

/* 2.You want to printout list of all facilities & cost to members.
     How to retrieve a list of only facility names and cost? */
     
     SELECT  DISTINCT name,membercost FROM cd.facilities;
     
/* 3.How can you produce a list of facilities that charge a fee to members? */

     SELECT * FROM cd.facilities
     WHERE membercost != 0;

/* 4.How can you produce a list of facilities that charge a fee to members,
     and that fee is less than 1/50th of monthly maintainance cost?
     Return the facid,facilityname,member cost, and monthly maintainance. */
     
     SELECT facid,name,membercost,monthlymaintenance 
     FROM cd.facilities
     WHERE membercost>0 AND membercost < monthlymaintenance/50;
     
/* 5.How can you produce a list of all facilities with the word 'Tennis' in 
     their name? */
     
     SELECT * FROM cd.facilities
     WHERE name LIKE '%Tennis%';
     
/* 6.How can you retrieve the details of facilities with ID 1 AND 5?
     Try do it without using OR operator */
     
     SELECT * FROM cd.facilities
     WHERE facid IN (1,5);
     
/* 7.How can you produce a list of members who joined after the start of 
     September 2012? Return the memid,surname, firstname & joindate of members */
     
     SELECT memid,surname,firstname,joindate FROM cd.members
     WHERE joindate >= '2012-09-01';
     
/* 8.How can you produce an ordered list of the first 10 surnames in the 
     members table? The list must not contain dupicates.*/
     
     SELECT DISTINCT surname FROM cd.members
     ORDER BY surname ASC
     LIMIT 10 ;
     
/* 9.You would like to get the signup date of your last member.How can you 
     retrieve the information? */
     
     SELECT joindate FROM cd.members
     ORDER BY joindate DESC
     LIMIT 1;
     
/* 10.Produce a count of the number of facilities that have a cost of guests 
      of 10 or more */
      
      SELECT COUNT(*) FROM cd.facilities
      WHERE guestcost > 10;
      
/* 11.Produce a list of the total number of slots booked per facility in the 
      month of September 2012.Produce an output table consisting of facility 
      id and slots,sorted by the number of slots. */
      
      SELECT facid,SUM(slots) FROM cd.bookings
      WHERE starttime >= '2012-09-01' AND starttime <= '2012-10-01'
      GROUP BY facid
      ORDER BY SUM(slots);
      
/* 12.Produce a list of facilities with more than 1000 slots booked.Produce an 
      output table consisting of facility id and total slots,sorted by facility id.*/
      
      SELECT facid,SUM(slots) AS total_slots
      FROM cd.bookings
      GROUP BY facid
      HAVING SUM(slots) > 1000
      ORDER BY facid ASC;
      
/* 13.How can you produce a list of the starttimes for bookings for tennis courts,
      for the date '2012-09-21'? Return a list of starttime and facility name pairings
      ordered by the time. */
      
      SELECT cd.bookings.starttime ,cd.facilities.name FROM cd.facilities
      INNER JOIN cd.bookings
      ON cd.facilities.facid = cd.bookings.facid
      WHERE starttime >= '2012-09-21' AND starttime < '2012-09-22' 
      AND cd.facilities.facid IN (0,1)
      ORDER BY cd.bookings.starttime;
      
/* 14.How can you produce a list of the start times for bookings by members named 
      'David Farell'? */
      
      SELECT cd.bookings.starttime FROM cd.bookings
      INNER JOIN cd.members 
      ON cd.members.memid = cd.bookings.memid
      WHERE cd.members.firstname = 'David' AND cd.members.surname = 'Farrell';
     
      

     
     