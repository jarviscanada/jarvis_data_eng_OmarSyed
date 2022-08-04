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

SELECT date_trunc('hour', timestamp) + date_part('minute', timestamp):: int / 5 * interval '5 min' 
FROM host_usage;
CREATE FUNCTION round5(ts timestamp) RETURNS timestamp AS
$$
BEGIN
    RETURN date_trunc('hour', ts) + date_part('minute', ts):: int / 5 * interval '5 min';
END;
$$
    LANGUAGE PLPGSQL;
    
SELECT
    FIRST_VALUE(cpu_number) OVER (
    PARTITION BY cpu_number
    ORDER BY
    total_mem DESC
    AS cpu_number,
    id AS host_id,
    total_mem
FROM
    host_info;
   
SELECT
    usages.host_id,
    infos.hostname,
    rounder(usages.timestamp) AS times,
    AVG((infos.total_mem - usages.memory_free)/infos.total_mem*100) AS avg_used_mem
FROM host_info AS infos INNER JOIN host_usage AS usages ON infos.id = usages.host_id

GROUP BY
	host_id,
	round5(
	CAST(timestamp AS timestamp)
  	);

--Question 3--
SELECT
	host_id,
	round5(
	CAST(timestamp AS timestamp)
  	) AS timestamp,
  	COUNT(timestamp) AS num_data_points
FROM
  	host_usage
GROUP BY
  	host_id,
  	round5(
    	CAST(timestamp AS timestamp)
  	)
HAVING
  	COUNT(timestamp) < 3;











