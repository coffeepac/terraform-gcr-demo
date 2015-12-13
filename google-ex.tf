# Configure the Google Cloud provider
provider "google" {
    account_file = "${file(\"account.json\")}"
    credentials = "${file(\"account.json\")}"
    project = "datagenerator-1082"
    region = "us-central1-c"
}
provider "googlecli" {
    credentials = "${file(\"account.json\")}"
    project = "datagenerator-1082"
    region = "us-central1-c"
}

resource "google_container_cluster" "pac-dev-cluster" {
    name = "pacs-in-your-face"
    zone = "us-central1-c"
    initial_node_count = 1

    master_auth {
        username = "cpac"
        password = "HateMachine"
    }

    node_config {
        oauth_scopes = [
            "https://www.googleapis.com/auth/compute",
            "https://www.googleapis.com/auth/devstorage.read_only",
            "https://www.googleapis.com/auth/logging.write",
            "https://www.googleapis.com/auth/monitoring",
            "https://www.googleapis.com/auth/cloud-platform"
        ]
    }
}

resource "googlecli_container_replica_controller" "producer-orc" {
    name = "producer-suckit"
    docker_image = "gcr.io/hx-test/source-master"
    external_port = "8080"
    container_name = "${google_container_cluster.pac-dev-cluster.name}"
    zone = "${google_container_cluster.pac-dev-cluster.zone}"
}

output "ip" {
    value = "${googlecli_container_replica_controller.producer-orc.external_ip}"
}

resource "google_dns_record_set" "prodorc" {
    managed_zone = "dummy-22acacia"
    name = "suckit22.22acacia.xyz."
    type = "A"
    ttl = 300
    rrdatas = ["${googlecli_container_replica_controller.producer-orc.external_ip}"]
}
