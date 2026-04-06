package hello

import "testing"

func TestText(t *testing.T) {
	if got, want := Text(), "Hello World!"; got != want {
		t.Errorf("Text() = %q, want %q", got, want)
	}
}
