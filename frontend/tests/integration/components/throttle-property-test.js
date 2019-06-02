import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';
import { render, settled } from '@ember/test-helpers';
import hbs from 'htmlbars-inline-precompile';

module('Integration | Component | throttle-property', function(hooks) {
  setupRenderingTest(hooks);

  test('it renders', async function(assert) {
    this.propertyToThrottle = 1;

    await render(hbs`
      {{#throttle-property property=propertyToThrottle milliseconds=1000 as |property|}}
        {{property}}
      {{/throttle-property}}
    `);

    this.set('propertyToThrottle', 2);
    this.set('propertyToThrottle', 3);

    assert.equal(this.element.textContent.trim(), '1');

    this.set('propertyToThrottle', 4);
    this.set('propertyToThrottle', 5);

    assert.equal(this.element.textContent.trim(), '1');

    this.set('propertyToThrottle', 6);
    this.set('propertyToThrottle', 7);

    await settled();

    assert.equal(this.element.textContent.trim(), '7');

    // property gets updated many more times than 3, but it throttles
  });

  test('it passes through the prop even without subsequent updates', async function(assert) {
    this.propertyToThrottle = 1;

    await render(hbs`
      {{#throttle-property property=propertyToThrottle milliseconds=1000 as |property|}}
        {{property}}
      {{/throttle-property}}
    `);

    assert.equal(this.element.textContent.trim(), '1')
  });
});
