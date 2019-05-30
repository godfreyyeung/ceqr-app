import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';
import { render } from '@ember/test-helpers';
import hbs from 'htmlbars-inline-precompile';

module('Integration | Component | transportation/project-map/census-tract-popup', function(hooks) {
  setupRenderingTest(hooks);

  test('it renders', async function(assert) {
    this.map = {
      instance: {
        queryRenderedFeatures: () => [],
        on() {},
        off() {},
      },
    };

    await render(hbs`
      {{transportation/project-map/census-tract-popup
        map=map
        layerId='test'}}
    `);

    assert.equal(this.element.textContent.trim(), '');
  });
});
