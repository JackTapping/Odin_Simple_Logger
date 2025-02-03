package log

import "core:fmt" // used for the fmt.tprint proc to build a string for the file write
import "core:time" // used to get the current time and date
import "core:os" // used to open and write to the text file 

main :: proc(){
	
	// set up for getting the time and turning in to string for file write
	now : time.Time = time.now()
	time_buf : [time.MIN_HMS_LEN]u8
	date_buf: [time.MIN_YYYY_DATE_LEN]u8
	
	//opening the text file

	handle : os.Handle //holds on to where the file is in memory 
	error : os.Error // gives us an error type if the file fails to load
	handle, error = os.open("logger.txt", os.O_APPEND)// opening in append mode the file and giving handle the memory address 

	//String that will be constructed and writen to file
	log_string : string
	some_int : int // im not sure why the write_string proc returns and in :)
	
	number_of_writes : int = 0
	for number_of_writes < 10{

		//checking to see if 5 seconds has passed since time was set
		if time.duration_seconds(time.since(now)) > 5 {

			//resetting the time so it is up to date and if condition needs
			//to wait another 5 seconds 
			now = time.now()
			
			// using fmt.tprint to "construct" a string as 
			// string concats only work on constant string in odin 
			log_string = fmt.tprint(
				time.to_string_yyyy_mm_dd(now, date_buf[:]),
				"  ||  ", 
				time.time_to_string_hms(now, time_buf[:]),
				"\n")
		
			//writing the string to the logger.text file
			some_int, error = os.write_string(handle, log_string)

			//incrementing the number of writes so the loop ends
			number_of_writes += 1
		}

	}
	
	// closign the file not really need in this example as the program ends here
	// and our OS should free up the memory once the programe ends
	error = os.close(handle)
}
