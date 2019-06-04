import { module, test } from 'qunit';
import { setupTest } from 'ember-qunit';
import setupMirage from 'ember-cli-mirage/test-support/setup-mirage';

module('Unit | Model | community facilities analysis', function(hooks) {
  setupTest(hooks);
  setupMirage(hooks);

  test('it correctly calculates child care impact', async function(assert) {
    let analysisMirage = server.create('solid-waste-analysis', 'childCareImpact');
    let project = await this.owner.lookup('service:store').findRecord(
      'project', analysisMirage.projectId, { include: 'solid-waste-analysis' }
    );
    let analysis = await project.get('solidWasteAnalysis');

    assert.equal(analysis.describeStorage, 'boop');
  });

});
