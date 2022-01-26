###### Deploying VM ###

resource "google_service_account" "sa" {
  account_id   = "dunhumby-service-account"
  display_name = "dunhumby-service-account-custom"
}



resource "google_compute_instance" "default" {
  name         = "dh-datapipeline"
  machine_type = "e2-medium"
  zone         = "us-central1-a"
  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    } 
  }

  network_interface {
    network = "dunnhumby-vpc"
    subnetwork = "dunnhumby-subnet"
     access_config {
      // Ephemeral public IP
    }

  }

  metadata_startup_script = <<SCRIPT
    sudo apt-get update -y
    sudo apt-get  install docker.io -y
    docker pull tutum/hello-world 
    docker run --expose 8080 tutum/hello-world bash
    SCRIPT


  service_account {
   
    email  = google_service_account.sa.email
    scopes = ["cloud-platform"]
  }


} 