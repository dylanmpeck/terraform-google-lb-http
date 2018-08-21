/*
 * Copyright 2018 Google Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

provider google {
  region  = "${var.region}"
  project = "${var.service_project}"
}

module "gce-lb-http" {
  source            = "../../"
  name              = "group-http-lb"
  project           = "${var.service_project}"
  target_tags       = ["${module.mig1.target_tags}"]
  firewall_projects = ["${var.host_project}"]
  firewall_networks = ["${var.network}"]

  backends = {
    "0" = [
      {
        group = "${module.mig1.instance_group}"
      },
    ]
  }

  backend_params = [
    // health check path, port name, port number, timeout seconds.
    "/,http,80,10",
  ]
}
