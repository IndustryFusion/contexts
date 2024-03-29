#
# Copyright (c) 2024 Intel Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

PYSHACL=pyshacl -i rdfs
RDFPIPE=rdfpipe
test: base_entities filter_entities base_shacl filter_shacl
base_entities:
	$(PYSHACL) -s $@.ttl ../$@.ttl

filter_entities: base_entities
	#echo $(addprefix ../, $(addsuffix .ttl, $^))
	$(RDFPIPE) $(addprefix ../, $(addsuffix .ttl, $^)) ../$@.ttl | $(PYSHACL) -s $@.ttl -
base_shacl: base_entities
	$(RDFPIPE) $(addprefix ../, $(addsuffix .ttl, $^)) ../$@.ttl | $(PYSHACL) -s shacl.ttl -

filter_shacl: filter_entities base_entities
	$(RDFPIPE) $(addprefix ../, $(addsuffix .ttl, $^)) ../$@.ttl | $(PYSHACL) -s shacl.ttl -