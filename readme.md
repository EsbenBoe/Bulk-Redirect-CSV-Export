# Bulk-Redirect-CSV-Export
Searches Cloudflare's Bulk Redirect List for each paginated result and exports them back out to CSV.

# The Problem

For users who manage their Bulk Redirects via a CSV. Cloudflare only allows the ability to import via CSV and not export. This means you must managed your CSV locally rather than rely on Cloudflare to export your original CSV file. We are able to use the results from listing items inside the list ID and export them back out to a CSV.
# Setup

```
url="https://api.cloudflare.com/client/v4/accounts/<account_id>/rules/lists/<list_id>/items?cursor="
email="user@example.com"
key="yourglobablapikeyhere"
```

Update the variables with your account id, email and api key.

# Output

```
root@DESKTOP-HQOGOIQ:/home/seaneustace# chmod +x csv.sh
root@DESKTOP-HQOGOIQ:/home/seaneustace# ./csv.sh
Sean's Bulk Redirect CSV Exporter:
Enter a List ID: 123456789
Results saved to results.csv
```
