import os
from twilio.rest import Client


# Find your Account SID and Auth Token at twilio.com/console
# and set the environment variables. See http://twil.io/secure
account_sid = os.environ['TWILIO_ACCOUNT_SID']
auth_token = os.environ['TWILIO_AUTH_TOKEN']
client = Client(account_sid, auth_token)

validation_request = client.validation_requests \
                           .create(
                                friendly_name='My Home Phone Number',
                                phone_number='+14158675310'
                            )

print(validation_request.friendly_name)