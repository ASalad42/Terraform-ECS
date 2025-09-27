output "frontend_alb_url" {
  value = "http://${module.frontend_alb.alb_dns_name}"
}