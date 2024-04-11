provider "google" {
  project = "quixotic-prism-412316"  
  region  = "us-east1"
}
 
# Create a new VPC network
resource "google_compute_network" "my_network" {
  name = "airhunde1-vpc"
}
 
# Create subnet for the VPC (Public)
resource "google_compute_subnetwork" "public_subnet" {
  name          = "airhunde-public1-subnet"
  region        = "us-east1"  # Update with your desired region
  network       = google_compute_network.my_network.self_link
  ip_cidr_range = "10.0.2.0/24"  # Update with your desired CIDR range for public subnet
}
 
# Create subnet for the VPC (Private)
resource "google_compute_subnetwork" "private_subnet" {
  name          = "airhunde-private1-subnet"
  region        = "us-east1"  # Update with your desired region
  network       = google_compute_network.my_network.self_link
  ip_cidr_range = "10.0.3.0/24"  # Update with your desired CIDR range for private subnet
}
 
# Create a firewall rule to allow traffic on the application port
resource "google_compute_firewall" "allow_app_port" {
  name    = "allow-application-port"
  network = google_compute_network.my_network.name
 
  allow {
    protocol = "tcp"
    ports    = ["8080"]  # Update with your application port
  }
 
  source_ranges = ["0.0.0.0/0"]  # Update with your desired source IP range
}
 
# Create a Google Compute Engine instance with Container
resource "google_compute_instance" "my_instance" {
  name         = "airhunde1-vm"
  machine_type = "e2-medium"
  zone         = "us-east1-b"
 
  boot_disk {
    initialize_params {
      image = "cos-cloud/cos-stable"
    }
  }
 
  network_interface {
    subnetwork = google_compute_subnetwork.public_subnet.id
    access_config {}
  }
 
  metadata = {
    gce-container-declaration = <<EOT
spec:
  containers:
    - name: airhunde1-container
      image: 'us-east1-docker.pkg.dev/quixotic-prism-412316/assignment2/myflask_app@sha256:b4f1f4d99150bf7cb688a9c7d4ac171f48a19830dde55d7b131e2c06ba4d3252'
      stdin: false
      tty: false
  restartPolicy: Always
EOT
  }
 
  service_account {
    scopes = ["cloud-platform"]
  }
 
  tags = ["http-server", "https-server"]
}
 
# Output the instance IP address
output "instance_ip" {
  value = google_compute_instance.my_instance.network_interface.0.access_config.0.nat_ip
} 