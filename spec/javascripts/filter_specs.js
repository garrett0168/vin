'use strict';

describe('filter', function() {
  beforeEach(module('vin'));

  describe('humanize', function() {
    it('should humanize a string',
        inject(function(humanizeFilter) {
      expect(humanizeFilter('AUTOMATED_MANUAL')).toBe('Automated Manual');
      expect(humanizeFilter('gas')).toBe('Gas');
      expect(humanizeFilter('AUTOMATIC')).toBe('Automatic');
      expect(humanizeFilter(undefined)).toBe('');
      expect(humanizeFilter(null)).toBe('');
    }));
  });
});
