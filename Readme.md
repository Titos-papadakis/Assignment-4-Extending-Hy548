1)
a) εγκατάσταση του crd: kubectl apply -f fruit-crd.yaml
b) δημιουργία αντικειμένου: kubectl apply -f my-apple.yaml
c) επιβεβαίωση στοιχείων: kubectl get fruit apple -o yaml
d) λίστα φρούτων: kubectl get fruits

2)
a) build και push του image:
docker build -t titoyannis/fruit-controller:v1 .
docker login
docker push titoyannis/fruit-controller:v1
b) εγκατάσταση Greeting CRD και ανάπτυξη του Controller:
kubectl apply -f greeting-crd.yaml
kubectl apply -f greeting-controller.yaml
έλεγχος pod με kubectl get pods και logs με kubectl logs -l app=greeting-controller. είδα ότι έβγαλε Activity 'login_via_client' succeeded οπότε ο controller τρέχει κανονικά.

3)
a) αλλαγή κώδικα webhook_controller.py για ssl/443.
build με το ειδικό dockerfile:
docker build -f Dockerfile.webhook -t titoyannis/webhook-controller:v1 .
docker push titoyannis/webhook-controller:v1
b) δημιουργία ssl secret:
kubectl create secret tls webhook-certs --cert=tls.crt --key=tls.key
kubectl apply -f webhook.yaml

verification:
το pod είναι running και στα logs φαίνεται ότι ο flask σηκώθηκε σε https στην 443 (Running on https://0.0.0.0:443/).