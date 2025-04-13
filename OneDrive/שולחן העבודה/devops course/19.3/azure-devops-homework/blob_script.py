import os
from azure.storage.blob import BlobServiceClient
import random
import string

account_a_connection_string = os.environ["STORAGE_A_CONN"]
account_b_connection_string = os.environ["STORAGE_B_CONN"]
container_a = "container-a"
container_b = "container-b"

blob_service_a = BlobServiceClient.from_connection_string(account_a_connection_string)
blob_service_b = BlobServiceClient.from_connection_string(account_b_connection_string)
container_client_a = blob_service_a.get_container_client(container_a)
container_client_b = blob_service_b.get_container_client(container_b)

for i in range(100):
    blob_name = f"file_{i}.txt"
    content = ''.join(random.choices(string.ascii_letters + string.digits, k=100))
    container_client_a.upload_blob(name=blob_name, data=content, overwrite=True)
    print(f"Uploaded {blob_name} to {container_a}")

    blob_data = container_client_a.download_blob(blob_name).readall()
    container_client_b.upload_blob(name=blob_name, data=blob_data, overwrite=True)
    print(f"Copied {blob_name} to {container_b}")
