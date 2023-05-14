# タスク実行ロール
resource "aws_iam_role" "ecs_task_execution" {
  name = "${local.name_prefix}-${local.service_name}-ecs-task-execution"

  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : {
            "Service" : "ecs-tasks.amazonaws.com"
          },
          "Action" : "sts:AssumeRole"
        }
      ]
    }
  )

  tags = {
    Name = "${local.name_prefix}-${local.service_name}-ecs-task-execution"
  }
}

data "aws_iam_policy" "ecs_task_execution" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# タスク実行権限を付与
resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  role = aws_iam_role.ecs_task_execution.name
  policy_arn = data.aws_iam_policy.ecs_task_execution.arn
}

# パラメータストア参照権限
resource "aws_iam_policy" "ssm" {
  name = "${local.name_prefix}-${local.service_name}-ssm"
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "ssm:GetParameters",
            "ssm:GetParameter"
          ],
          "Resource" : "arn:aws:ssm:${data.aws_region.current.id}:${data.aws_caller_identity.self.account_id}:parameter/${local.system_name}/${local.env_name}/*"
        }
      ]
    }
  )

  tags = {
    Name = "${local.name_prefix}-${local.service_name}-ssm"
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_ssm" {
  role = aws_iam_role.ecs_task_execution.name
  policy_arn = aws_iam_policy.ssm.arn
}

# ECSコンテナの中に入ることができるロール
resource "aws_iam_role" "ecs_task" {
  name = "${local.name_prefix}-${local.service_name}-ecs-task"

  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : {
            "Service" : "ecs-tasks.amazonaws.com"
          },
          "Action" : "sts:AssumeRole"
        }
      ]
    }
  )

  tags = {
    Name = "${local.name_prefix}-${local.service_name}-ecs-task"
  }
}

# ECSコンテナに入る権限
resource "aws_iam_role_policy" "ecs_task_ssm" {
  name = "ssm"
  role = aws_iam_role.ecs_task.id

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "ssmmessages:CreateControlChannel",
            "ssmmessages:CreateDataChannel",
            "ssmmessages:OpenControlChannel",
            "ssmmessages:OpenDataChannel"
          ],
          "Resource" : "*"
        }
      ]
    }
  )
}
