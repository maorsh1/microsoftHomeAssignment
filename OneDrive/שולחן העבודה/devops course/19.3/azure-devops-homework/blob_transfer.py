import os
from azure.storage.blob import BlobServiceClient, ContainerClient, BlobClient

conn_str_a = os.environ.get("STORAGE_A_CONN")
conn_str_b = os.environ.get("STORAGE_B_CONN")

container_a = "container-a"
container_b = "container-b"

blob_service_a = BlobServiceClient.from_connection_string(conn_str_a)
blob_service_b = BlobServiceClient.from_connection_string(conn_str_b)

blob_service_a.create_container(container_a)
blob_service_b.create_container(container_b)

for i in range(1, 101):
    file_name = f"file_{i}.txt"
    content = f"This is blob file number {i}"
    
    with open(file_name, "w") as f:
        f.write(content)
    
    blob_client_a = blob_service_a.get_blob_client(container=container_a, blob=file_name)
    with open(file_name, "rb") as data:
        blob_client_a.upload_blob(data)

    blob_data = blob_client_a.download_blob().readall()

    blob_client_b = blob_service_b.get_blob_client(container=container_b, blob=file_name)
    blob_client_b.upload_blob(blob_data)

    os.remove(file_name)

print("All 100 blobs uploaded to A and copied to B.")
