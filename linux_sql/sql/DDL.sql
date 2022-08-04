# connect to the psql instance
psql -h localhost -U postgres -W

# list all database
postgres=# \l

# create a database
postgres=# CREATE DATABASE host_agent;

# connect to the new database
postgres=# \c host_agent;

# Create Hardware Specification Table
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
PRIMARY KEY(id));

# Populate Table
INSERT INTO host_info (id, hostname, cpu_number, cpu_architecture, cpu_model, cpu_mhz, L2_cache, total_mem, timestamp)
VALUES (1, 'spry-framework-236416.internal', 1, 'x86_64', 'Intel(R) Xeon(R) CPU @ 2.30GHz', 2300.000, 256, 601324, '2022-06-29 17:49:53');

# Create Resource Usage Table
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

# Populate Table
INSERT INTO host_usage ("timestamp", host_id, memory_free, cpu_idle, cpu_kernel, disk_io, disk_available)
VALUES ('2022-07-29 16:53:28', 1, 256, 95, 0, 0, 31220);
