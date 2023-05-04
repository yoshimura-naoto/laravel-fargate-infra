module "nginx" {
  # モジュールのパス
  source = "../../../../modules/ecr"

  # 変数に値代入
  name = "${local.name_prefix}-${local.service_name}-nginx"
}

module "php" {
  source = "../../../../modules/ecr"

  name = "${local.name_prefix}-${local.service_name}-php"
}
