-- SELECT * 
-- FROM drug
-- LIMIT 5;

-- SELECT * 
-- FROM prescriber
-- LIMIT 5;

SELECT * 
FROM prescription
LIMIT 5;


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



