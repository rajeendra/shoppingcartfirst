import 'package:flutter/material.dart';
import 'package:flutter_braintree/flutter_braintree.dart';

class APIPayPalBraintree {

  static final String tokenizationKey = 'sandbox_rzmg7798_7grbtgq7qdkrd49y';

  //void showNonce(BraintreePaymentMethodNonce nonce, BuildContext context) {
  void showNonce(nonce, BuildContext context) {
    //final nonce = result.paymentMethodNonce;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Payment successful',
          style: TextStyle(
              color: Colors.green
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text('payment method nonce',
              style: TextStyle(
                fontSize: 16,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold,
                //color: Colors.green
              ),
            ),
            SizedBox(height: 8),
            Text('Nonce: ${nonce.nonce}'),
            SizedBox(height: 16),
            Text('Type label: ${nonce.typeLabel}'),
            SizedBox(height: 16),
            Text('Description: ${nonce.description}'),
          ],
        ),
      ),
    );
  }

  Future<BraintreePaymentMethodNonce?> doPayment(double amount) async{
    var request = BraintreeDropInRequest(
      tokenizationKey: tokenizationKey,
      collectDeviceData: true,
      googlePaymentRequest: BraintreeGooglePaymentRequest(
        totalPrice: amount.toString(),
        currencyCode: 'USD',
        billingAddressRequired: false,
      ),
      paypalRequest: BraintreePayPalRequest(
        amount: amount.toString(),
        displayName: 'Example company',
      ),
      cardEnabled: true,
    );
    final result = await BraintreeDropIn.start(request);
    return result?.paymentMethodNonce;
  }

}