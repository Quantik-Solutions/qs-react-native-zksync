import TestData from '../testData.json';

describe('Example', () => {
  beforeEach(async () => {
    await device.reloadReactNative();
  });

  it('should show the proper result of pubkeyhash', async () => {
    await element(by.id('pubKeyHash')).tap();
    await expect(
      element(by.text(TestData.correctFinalPubKeyHash)),
    ).toBeVisible();
  });

  it('should show the proper result of signMusig', async () => {
    await element(by.id('signMusig')).tap();
    await expect(
      element(by.text(TestData.verifiedSignatureResult)),
    ).toBeVisible();
  });

  it('should show the proper result of seedToPubKey', async () => {
    await element(by.id('seedToPubKey')).tap();
    await expect(element(by.text(TestData.hexPrivateKey))).toBeVisible();
  });

  it('should show the proper result of pKeyToPubKey', async () => {
    await element(by.id('pKeyToPubKey')).tap();
    await expect(
      element(by.text(TestData.verifiedSignatureResult.substr(0, 64))),
    ).toBeVisible();
  });
});
