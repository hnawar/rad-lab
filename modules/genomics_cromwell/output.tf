/**
 * Copyright 2021 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

output "Cromell_server_internal_IP" {
  value = google_compute_instance.cromwell_server.network_interface[0].network_ip

}

output "Cromwell_service_account_email" {
  value = google_service_account.cromwell_service_account.email
}

output "GCS_Bucket_URL" {
  value = google_storage_bucket.cromwell_workflow_bucket.url
}
