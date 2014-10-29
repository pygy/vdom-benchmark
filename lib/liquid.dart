library vdom_benchmark.liquid;

import 'dart:html' as html;
import 'package:vdom_benchmark/benchmark.dart';
import 'package:vdom_benchmark/generator.dart' as g;
import 'package:vdom/vdom.dart' as v;
import 'package:liquid/liquid.dart' as l;

class NodeComponent extends l.VComponent {
  g.Node _node;

  NodeComponent(l.ComponentBase parent, this._node) :
    super(parent, new html.DivElement());

  void updateProperties(g.Node node) {
    _node = node;
    if (_node.dirty) {
      invalidate();
    }
  }

  /// Should be auto-generated by pub transformer
  static l.VComponentElement virtual(Object key, l.ComponentBase parent, g.Node node) {
    return new l.VComponentElement(key, (component) {
      if (component == null) {
        return new NodeComponent(parent, node);
      } else {
        component.updateProperties(node);
        return component;
      }
    });
  }

  List<v.Node> build() {
    final result = [];
    final children = _node.children;
    if (children != null) {
      for (var i = 0; i < children.length; i++) {
        final c = children[i];
        if (c.children == null) {
          result.add(LeafComponent.virtual(c.key, this, c));
        } else {
          result.add(NodeComponent.virtual(c.key, this, c));
        }
      }
    }
    return result;
  }

  String toString() => 'Node: [$_node]';
}

class LeafComponent extends l.VComponent {
  g.Node _node;

  LeafComponent(l.ComponentBase parent, this._node) : super(parent, new html.SpanElement());

  void updateProperties(g.Node node) {
    _node = node;
    if (_node.dirty) {
      invalidate();
    }
  }

  /// Should be auto-generated by pub transformer
  static l.VComponentElement virtual(Object key, l.ComponentBase parent, g.Node node) {
    return new l.VComponentElement(key, (component) {
      if (component == null) {
        return new LeafComponent(parent, node);
      } else {
        component.updateProperties(node);
        return component;
      }
    });
  }

  List<v.Node> build() {
    return [new v.Text(0, _node.key.toString())];
  }

  String toString() => 'Leaf: [${_node.key}]';
}


class Benchmark extends BenchmarkBase {
  List<g.Node> a;
  List<g.Node> b;
  html.Element _container;

  l.RootComponent _root;
  l.VComponentElement _vComponent;
  html.Element _rootElement;

  Benchmark(this.a, this.b, this._container) : super('VComponent');

  void render() {
    _vComponent = NodeComponent.virtual(0, _root, new g.Node(0, false, this.a));
    _rootElement = _vComponent.render();
    _container.append(_rootElement);
    _root.attached();
  }

  void update() {
    final newVComponent = NodeComponent.virtual(0, _root, new g.Node(0, true, this.b));
    _vComponent.diff(newVComponent);
    _root.update();
  }

  void setup() {
    _root = new l.RootComponent();
  }

  void teardown() {
    _rootElement.remove();
    _root = null;
  }
}