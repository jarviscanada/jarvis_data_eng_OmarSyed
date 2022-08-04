--Question 1--
CREATE VIEW cpu_by_mem AS
SELECT
	FIRST_VALUE(cpu)number) OVER (PARTITION BY id ORDER
	total_mem DESC) AS cpu_number,
	id as host_id,
	total_mem
FROM
	PUBLIC.host_info
ORDER BY
	cpu_number;
--Question 2--
INSERT INTO host_usage ("timestamp", host_id, memory_free, cpu_idle, cpu_kernel, disk_io,
                        disk_available)
VALUES ('2019-05-29 15:00:00.000', 1, 300000, 90, 4, 2, 3);
INSERT INTO host_usage ("timestamp", host_id, memory_free, cpu_idle, cpu_kernel, disk_io,
                        disk_available)
VALUES ('2019-05-29 15:01:00.000', 1, 200000, 90, 4, 2, 3);

CREATE TABLE temp AS
SELECT
	hostname,
	id,
	total_mem,
	timestamp as timestamp,
	CAST(memory_free*1024 AS INT) AS memory_free
FROM
	PUBLIC.host_info;

ALTER TABLE temp
ADD COLUMN rounded timestamp;
ALTER TABLE temp
ADD COLUMN memPercentNum NUMERIC;
ALTER TABLE temp
ADD COLUMN memPercentUsed INT;

UPDATE temp
SET rounded = date_trunc('hour', timestamp) + INTERVAL '5 min' * ROUND(date_part('minute', timestamp) / 5.0);
UPDATE temp
SET memPercentNum = CAST(memory_free AS NUMERIC)/total_mem*100;
UPDATE temp
SET memPercentUsed=CAST(100 - percent_mem_numeric AS INT);

CREATE VIEW memAvg AS
SELECT
	hostname AS host_name,
	total_mem AS total_memory,
	CAST(AVG(percent_mem_used) AS SMALLINT) AS used_memory_percentage
FROM
	avg_mem_temp
GROUP BY
	id,hostname,total_mem;










