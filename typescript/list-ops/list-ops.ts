class Node<A> {
  value: A;

  constructor(value: A) {
    this.value = value;
  }
}

interface Node<A> {
  next: Node<A>;
}

export default class List<A> {
  head: Node<A> | null;
  tail: Node<A> | null;

  constructor(items?: A[]) {
    this.head = null;
    this.tail = null;

    if (items) {
      this.fromArray(items);
    }
  }

  private fromArray(array: A[]): void {
    for (let index = array.length - 1; index >= 0; index--) {
      this.addNode(array[index]);
    }
  }

  private addNode(item: A): List<A> {
    const node = new Node(item);
    if (this.head == null) {
      this.head = node;
      this.tail = node;
    } else {
      node.next = this.head;
      this.head = node;
    }
    return this;
  }

  private copy(): List<A> {
    if (!this.head) return this;
    return this.foldr((list, el) => list.addNode(el), new List<A>());
  }

  get values(): A[] {
    return this.foldl((acc: A[], curr: A): A[] => {
      acc.push(curr);
      return acc;
    }, [] as A[]);
  }

  length(): number {
    return this.foldl((acc, _) => ++acc, 0);
  }

  append(list: List<A>): List<A> {
    if (!list.head) return this;
    const copy = this.copy();
    if (!copy.tail) {
      copy.head = list.head;
      return copy;
    }

    copy.tail.next = list.head;
    return copy;
  }

  concat(list: List<List<A>>): List<A> {
    if (!list.head) return this;
    const flattenedList = list.foldr(
      (acc, curr) => (curr.head ? curr.append(acc) : acc),
      new List<A>()
    );
    return this.append(flattenedList);
  }

  foldl<B>(fn: (acc: B, curr: A) => B, initial: B): B {
    if (!this.head) return initial;

    const recurse = (accumulator: B, current: Node<A>): B => {
      if (current.next == null) return fn(accumulator, current.value);
      return recurse(fn(accumulator, current.value), current.next);
    };

    return recurse(initial, this.head);
  }

  foldr<B>(fn: (b: B, a: A) => B, initial: B): B {
    return this.reverse().foldl(fn, initial);
  }

  map<B>(fn: (a: A) => B): List<B> {
    return this.foldr(
      (acc: List<B>, current: A): List<B> => acc.addNode(fn(current)),
      new List<B>()
    );
  }

  reverse(): List<A> {
    return this.foldl(
      (acc: List<A>, current: A): List<A> => acc.addNode(current),
      new List<A>()
    );
  }

  filter(fn: (a: A) => boolean): List<A> {
    return this.foldr(
      (acc: List<A>, current: A): List<A> =>
        fn(current) ? acc.addNode(current) : acc,
      new List<A>()
    );
  }
}
