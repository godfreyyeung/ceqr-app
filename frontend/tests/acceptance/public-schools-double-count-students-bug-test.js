import { module, test } from 'qunit';
import { visit, currentURL, pauseTest } from '@ember/test-helpers';
import { setupApplicationTest } from 'ember-qunit';
import setupMirage from 'ember-cli-mirage/test-support/setup-mirage';
import { authenticateSession } from 'ember-simple-auth/test-support';

module('Acceptance | public schools double count students bug', function(hooks) {
  setupApplicationTest(hooks);
  setupMirage(hooks);

  test('User sees correct calculation for projected enrollemnt with project', async function(assert) {
    this.server.create('user');
    this.server.create('public-schools-analysis', 'analysisWithNoSchools');
    this.server.create('bbl');

    await authenticateSession({
      userId: 1,
    });

    await visit('/project/1/public-schools/with-action');

    await pauseTest();
  });
});
