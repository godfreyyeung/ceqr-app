import { module, skip } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';
import { render, pauseTest } from '@ember/test-helpers';
import hbs from 'htmlbars-inline-precompile';

module('Integration | Component | transportation/project-map', function(hooks) {
  setupRenderingTest(hooks);

  skip('it renders', async function(assert) {
    // Set any properties with this.set('myProperty', 'value');
    // Handle any actions with this.set('myAction', function(val) { ... });

    await render(hbs`{{transportation/project-map}}`);

    assert.equal(this.element.textContent.trim(), '');
  });
});
