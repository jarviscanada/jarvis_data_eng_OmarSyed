DROP TABLE IF EXISTS PUBLIC.host_info CASCADE;
DROP TABLE IF EXISTS PUBLIC.host_usage CASCADE;

CREATE TABLE IF NOT EXISTS PUBLIC.host_info (
	id SERIAL NOT NULL,
	hostname VARCHAR(100) UNIQUE NOT NULL,
	cpu_number INT NOT NULL,
	cpu_architecture VARCHAR(100) NOT NULL,
	cpu_model VARCHAR(100) NOT NULL,
	cpu_mhz NUMERIC(7, 3) NOT NULL,
	L2_cache INT NOT NULL,
	total_mem INT NOT NULL,
	timestamp TIMESTAMP NOT NULL,
	PRIMARY KEY(id)
);

CREATE TABLE IF NOT EXISTS PUBLIC.host_usage (
	timestamp TIMESTAMP NOT NULL, 
	host_id INT NOT NULL, 
	memory_free INT NOT NULL, 
	cpu_idle NUMERIC NOT NULL, 
	cpu_kernel NUMERIC NOT NULL, 
	disk_io INT NOT NULL, 
	disk_available INT NOT NULL,
	PRIMARY KEY(timestamp, host_id), 
	FOREIGN KEY(host_id) REFERENCES PUBLIC.host_info(id)
);

