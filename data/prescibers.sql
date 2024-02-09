-- SELECT * 
-- FROM drug
-- LIMIT 5;

-- SELECT * 
-- FROM prescriber
-- LIMIT 5;

-- SELECT * 
-- FROM prescription
-- LIMIT 5;


-- For this exericse, you'll be working with a database derived from the Medicare Part D Prescriber Public Use File. More information about the data is contained in the Methodology PDF file. See also the included entity-relationship diagram.


-- 1
-- a. Which prescriber had the highest total number of claims (totaled over all drugs)? Report the npi and the total number of claims.
-- --answer 1912011792

-- SELECT npi, total_claim_count
-- FROM prescriber
-- INNER JOIN prescription
-- USING(npi)
-- GROUP BY 1, 2
-- ORDER BY 2 DESC;

-- b. Repeat the above, but this time report the nppes_provider_first_name, nppes_provider_last_org_name, specialty_description, and the total number of claims.
-- DONE! Below. NOTE that NPI is specifically not reported because it was left off.

-- SELECT total_claim_count, nppes_provider_first_name, nppes_provider_last_org_name, specialty_description
-- FROM prescriber
-- INNER JOIN prescription
-- USING(npi)
-- GROUP BY npi, 1,2,3,4
-- ORDER BY total_claim_count DESC;



-- 2
-- a. Which specialty had the most total number of claims (totaled over all drugs)?
-- Answer: Family Practice
-- SELECT specialty_description, SUM(total_claim_count)
-- FROM prescriber
-- JOIN prescription
-- USING(npi)
-- GROUP BY specialty_description
-- ORDER BY 2 DESC;

-- b. Which specialty had the most total number of claims for opioids?
-- Answer: Nurse Practitioner

-- SELECT specialty_description, COUNT(drug.opioid_drug_flag)
-- FROM prescriber
-- JOIN prescription
-- USING(npi)
-- JOIN drug
-- USING (drug_name)
-- GROUP BY specialty_description
-- ORDER BY 2 DESC;

-- c. Challenge Question: Are there any specialties that appear in the prescriber table that have no associated prescriptions in the prescription table?
-- SAVE THIS ONE FOR LATER....



-- 3
-- a. Which drug (generic_name) had the highest total drug cost?
-- Answer: "INSULIN GLARGINE,HUM.REC.ANLOG"

-- SELECT generic_name, SUM(total_drug_cost)
-- FROM prescription
-- JOIN drug
-- USING(drug_name)
-- GROUP BY generic_name
-- ORDER BY 2 DESC;

-- b. Which drug (generic_name) has the hightest total cost per day? Bonus: Round your cost per day column to 2 decimal places. Google ROUND to see how this works.
-- Answer: "LEDIPASVIR/SOFOSBUVIR"

-- SELECT generic_name, (SUM(total_drug_cost/total_day_supply)
-- FROM prescription
-- JOIN drug
-- USING(drug_name)
-- GROUP BY generic_name
-- ORDER BY 2 DESC;

-- Bonus: Round your cost per day column to 2 decimal places. Google ROUND to see how this works.

-- SELECT generic_name, ROUND(SUM(total_drug_cost/total_day_supply), 2) AS rounded_cost_per_day
-- FROM prescription
-- JOIN drug
-- USING(drug_name)
-- GROUP BY generic_name
-- ORDER BY 2 DESC;




-- 4
-- a. For each drug in the drug table, return the drug name and then a column named 'drug_type' which says 'opioid' for drugs which have opioid_drug_flag = 'Y', says 'antibiotic' for those drugs which have antibiotic_drug_flag = 'Y', and says 'neither' for all other drugs.

-- SELECT
-- drug_name,
-- CASE WHEN opioid_drug_flag = 'Y' THEN 'opioid'
-- 	WHEN antibiotic_drug_flag = 'Y' THEN 'antibiotic'
-- 	ELSE 'neither' END AS drug_type
-- FROM drug;

-- b. Building off of the query you wrote for part a, determine whether more was spent (total_drug_cost) on opioids or on antibiotics. Hint: Format the total costs as MONEY for easier comparision.

-- SELECT
-- ROUND(SUM(CASE WHEN opioid_drug_flag = 'Y' THEN (p.total_claim_count*p.total_drug_cost) ELSE '0' END),2) AS opioids,
-- ROUND(SUM(CASE WHEN antibiotic_drug_flag = 'Y' THEN (p.total_claim_count*p.total_drug_cost) ELSE '0' END),2) AS antibiotics
-- FROM drug
-- JOIN prescription AS p
-- USING (drug_name)


-- 5
-- a. How many CBSAs are in Tennessee? Warning: The cbsa table contains information for all states, not just Tennessee.

-- SELECT 
-- COUNT(DISTINCT c.cbsa)
-- FROM cbsa as c 
-- JOIN fips_county AS fc
-- USING(fipscounty)
-- WHERE state = 'TN';

-- b. Which cbsa has the largest combined population? Which has the smallest? Report the CBSA name and total population.

SELECT
	DISTINCT(c.cbsaname) AS cbsa_name,
	SUM(pop.population) AS combined_population
FROM cbsa AS c 
JOIN fips_county AS fc
USING(fipscounty)
JOIN population AS pop
USING (fipscounty)
GROUP BY 1
ORDER BY 2 DESC
LIMIT 2;

-- SELECT
-- 	DISTINCT(c.cbsaname) AS cbsa_name,
-- 	SUM(pop.population) AS combined_population
-- FROM cbsa AS c 
-- JOIN fips_county AS fc
-- USING(fipscounty)
-- JOIN population AS pop
-- USING (fipscounty)
-- GROUP BY 1
-- ORDER BY 2 ASC
-- LIMIT 2;

-- c. What is the largest (in terms of population) county which is not included in a CBSA? Report the county name and population.

SELECT
	DISTINCT(c.cbsaname) AS cbsa_name,
	SUM(pop.population) AS combined_population
FROM cbsa AS c 
JOIN fips_county AS fc
USING(fipscounty)
JOIN population AS pop
USING (fipscounty)
GROUP BY 1
ORDER BY 2 DESC
LIMIT 2;

-- 6
-- a. Find all rows in the prescription table where total_claims is at least 3000. Report the drug_name and the total_claim_count.

-- b. For each instance that you found in part a, add a column that indicates whether the drug is an opioid.

-- c. Add another column to you answer from the previous part which gives the prescriber first and last name associated with each row.



-- 7.
-- The goal of this exercise is to generate a full list of all pain management specialists in Nashville and the number of claims they had for each opioid. Hint: The results from all 3 parts will have 637 rows.

-- a. First, create a list of all npi/drug_name combinations for pain management specialists (specialty_description = 'Pain Management) in the city of Nashville (nppes_provider_city = 'NASHVILLE'), where the drug is an opioid (opiod_drug_flag = 'Y'). Warning: Double-check your query before running it. You will only need to use the prescriber and drug tables since you don't need the claims numbers yet.

SELECT
  pbr.npi,
  d.drug_name
FROM prescriber AS pbr
CROSS JOIN drug AS d
WHERE specialty_description = 'Pain Management'
AND
nppes_provider_city = 'NASHVILLE'
AND
d.opioid_drug_flag = 'Y'

