variable name     { }
variable key_path { }

resource "aws_key_pair" "btsol" {
  key_name   = "${var.name}"
  public_key = "${file(var.key_path)}"
}

output key_pair_name { value = "${aws_key_pair.btsol.key_name}"}
