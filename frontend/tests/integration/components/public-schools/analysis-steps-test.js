import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';
import { render } from '@ember/test-helpers';
import hbs from 'htmlbars-inline-precompile';
import setupMirage from 'ember-cli-mirage/test-support/setup-mirage';

module('Integration | Component | public-schools/analysis-steps', function(hooks) {
  setupRenderingTest(hooks);
  setupMirage(hooks);

  test('it renders', async function(assert) {
    this.owner.lookup('router:main').setupRouter();
    
    let project = server.create('project');
    let projectModel = await this.owner.lookup('service:store').findRecord('project', project.id);
    
    this.set('projectModel', projectModel);

    await render(hbs`{{public-schools/analysis-steps project=projectModel}}`);

    assert.ok(this.element);
  });
});
