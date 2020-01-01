/* 
  this is a simple implentation of (mutable!) linked lists
  some odd things: 
    (1) internally, these lists are actually "backwards" representations of the data. 
    an array of [1, 2, 3] will internally be a list (3 -> 2 -> 1). For this reason, foldr and foldl 
    are technically named backwards (from an internal perspective), but are kept that way to preserve 
    the deseried functionality for the outside caller.
    (2) obviously recursion does not allow for very long lists. this is a toy implementation meant for learning.
    (3) because I made the lists mutable (so as to preserve the value of a linked list), they change all 
    lists involved in an operation with the sole exception of empty lists (which are ignored)
    and reversed lists (because implementing immutable reversing was easier) -- hence foldl, which depends on
    reverse() is also immutable. 
*/

class ListNode<A> {
  value: A;

  constructor(value: A) {
    this.value = value;
  }
}

interface ListNode<A> {
  next: ListNode<A>;
}

export default class List<A> {
  head: ListNode<A> | null;
  tail: ListNode<A> | null;

  constructor(items?: A[]) {
    this.head = null;
    this.tail = null;

    if (items) {
      items.forEach(item => {
        this.addNode(item);
      });
    }
  }

  addNode(item: A): List<A> {
    const node = new ListNode(item);
    if (this.head == null) {
      this.head = node;
      this.tail = node;
    } else {
      node.next = this.head;
      this.head = node;
    }
    return this;
  }

  append(list: List<A>): List<A> {
    if (!list.tail) return this;
    if (!this.head) {
      this.head = list.head;
      return this;
    }

    list.tail.next = this.head;
    this.head = list.head;
    return this;
  }

  foldr<B>(fn: (b: B, a: A) => B, initial: B): B {
    if (!this.head) return initial;

    const recurser = (accumulator: B, current: ListNode<A>): B => {
      if (current == this.tail) return fn(accumulator, current.value);
      return recurser(fn(accumulator, current.value), current.next);
    };

    return recurser(initial, this.head);
  }

  reverse(): List<A> {
    return this.foldr(
      (acc: List<A>, current: A): List<A> => acc.addNode(current),
      new List<A>()
    );
  }

  filter(fn: (a: A) => boolean): List<A> {
    return this.foldl(
      (acc: List<A>, current: A): List<A> =>
        fn(current) ? acc.addNode(current) : acc,
      new List<A>()
    );
  }

  length(): number {
    return this.foldr((acc, _) => ++acc, 0);
  }

  foldl<B>(fn: (b: B, a: A) => B, initial: B): B {
    return this.reverse().foldr(fn, initial);
  }

  map<B>(fn: (a: A) => B): List<B> {
    return this.foldl(
      (acc: List<B>, current: A): List<B> => acc.addNode(fn(current)),
      new List<B>()
    );
  }

  concat(list: List<List<A>>): List<A> {
    if (!list.head) return this;
    const partial = list.foldr(
      (acc, curr) => (curr.head ? curr.append(acc) : acc),
      new List<A>()
    );
    return this.append(partial);
  }

  get values(): A[] {
    return this.foldr((acc: A[], curr: A): A[] => {
      acc.unshift(curr);
      return acc;
    }, [] as A[]);
  }
}

const list1 = new List([1, 2]);
const list2 = new List([3]);
const list3 = new List([]);
const list4 = new List([4, 5, 6]);
const listOfLists = new List([list2, list3, list4]);
