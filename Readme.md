# Kubernetes Custom Resource Definitions (CRDs) & Dynamic Admission Controller

An end-to-end Kubernetes governance and workload extension system built with custom CRDs, an event-driven Python controller (Kopf), and a TLS-secured dynamic admission webhook.

---

## 📌 Overview

This project extends the native Kubernetes control plane by introducing:
- **Custom Resource Definitions (CRDs)** to manage and automate custom lifecycle events directly via `kubectl`.
- **Event-Driven Controller (Kopf)** running in Python under strictly scoped RBAC permissions to monitor and reconcile custom resources.
- **Dynamic Admission Webhook** serving over HTTPS (port 443) using Flask to intercept and validate admission requests before persisting to `etcd`.

---

## 🏗 Architecture & Features

- **RBAC Hardening:** Deployed using custom ServiceAccounts, Roles, and RoleBindings restricting the controller to authorized namespaces and verbs.
- **SSL/TLS Termination:** Secure cluster communication via Kubernetes TLS Secrets containing X.509 certificates for the validating webhook.
- **Containerization:** Multi-target container builds packaged for minimal attack surface and deployed as cluster workloads.

---

## 🚀 Getting Started

### 1. Deploy Custom Resource Definitions (CRDs)

Apply the Custom Resource Definitions and create custom resources:

```bash
# Register the CRDs
kubectl apply -f crd.yaml

# Verify CRD status
kubectl get crd

# Deploy a custom resource manifest
kubectl apply -f resource-manifest.yaml
kubectl get crd-objects -o yaml
```

### 2. Deploy Controller with RBAC

Build and run the Python reconciliation controller:

```bash
# Build & tag Docker image
docker build -t titoyannis/fruit-controller:v1 .
docker push titoyannis/fruit-controller:v1

# Apply RBAC permissions and Controller deployment
kubectl apply -f greeting-crd.yaml
kubectl apply -f greeting-controller.yaml

# Inspect deployment status and streaming logs
kubectl get pods -l app=greeting-controller
kubectl logs -l app=greeting-controller -f
```

### 3. Deploy TLS Admission Webhook

Set up the HTTPS validating webhook:

```bash
# Create TLS secret for webhook authentication
kubectl create secret tls webhook-certs --cert=tls.crt --key=tls.key

# Build and push the webhook container
docker build -f Dockerfile.webhook -t titoyannis/webhook-controller:v1 .
docker push titoyannis/webhook-controller:v1

# Deploy webhook service and registration manifest
kubectl apply -f webhook.yaml

# Verify secure HTTPS listener on port 443
kubectl get pods -l app=webhook-controller
kubectl logs -l app=webhook-controller
```

---

## 🛠 Tech Stack

- **Orchestration:** Kubernetes (CRDs, Deployments, RBAC, Services, Secrets)
- **Controller Framework:** Python, Kopf
- **Admission Webhook:** Python, Flask, SSL/TLS (HTTPS :443)
- **Containerization:** Docker, Dockerfile
