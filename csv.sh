#!/bin/bash

email="user@example.com"
key="yourapikeyhere"
list_id=""
results=""

echo "Sean's Bulk Redirect Item Finder v4.2"

read -p 'Enter the List ID: ' list_id

url="https://api.cloudflare.com/client/v4/accounts/<account_id>/rules/lists/$list_id/items"
cursor=""

csv_results=""

while true; do
  response=$(curl -s "$url?cursor=$cursor" -H "X-Auth-Email: $email" -H "X-Auth-Key: $key")

  if [[ $(echo "$response" | jq -r '.result | length') -gt 0 ]]; then
    while IFS= read -r item; do
      source_url=$(echo "$item" | jq -r '.redirect.source_url')
      target_url=$(echo "$item" | jq -r '.redirect.target_url')
      status_code=$(echo "$item" | jq -r '.redirect.status_code')
      preserve_query_string=$(echo "$item" | jq -r '.redirect.preserve_query_string')
      include_subdomains=$(echo "$item" | jq -r '.redirect.include_subdomains')
      subpath_matching=$(echo "$item" | jq -r '.redirect.subpath_matching')
      preserve_path_suffix=$(echo "$item" | jq -r '.redirect.preserve_path_suffix')

      # Replace "null" with "false"
      [ "$source_url" == "null" ] && source_url="false"
      [ "$target_url" == "null" ] && target_url="false"
      [ "$status_code" == "null" ] && status_code="false"
      [ "$preserve_query_string" == "null" ] && preserve_query_string="false"
      [ "$include_subdomains" == "null" ] && include_subdomains="false"
      [ "$subpath_matching" == "null" ] && subpath_matching="false"
      [ "$preserve_path_suffix" == "null" ] && preserve_path_suffix="false"

      # Add the item's values to the CSV
      csv_results="${csv_results}\n$source_url,$target_url,$status_code,$preserve_query_string,$include_subdomains,$subpath_matching,$preserve_path_suffix"
    done <<< "$(echo "$response" | jq -c '.result[]')"

    # Check if there's a next page
    cursor=$(echo "$response" | jq -r '.result_info.cursors.after')
    if [[ "$cursor" == "null" ]]; then
      break
    fi
  else
    echo "No more items found in the list."
    break
  fi
done

# Save the results to a CSV file without the header
echo -e "$csv_results" | sed '1d' > results.csv
echo "Results saved to results.csv"
