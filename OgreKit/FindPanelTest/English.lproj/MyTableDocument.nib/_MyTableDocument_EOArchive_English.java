// _MyTableDocument_EOArchive_English.java
// Generated by EnterpriseObjects palette at 2004\u5e746\u670813\u65e5\u65e5\u66dc\u65e5 14\u664246\u520606\u79d2Asia/Tokyo

import com.webobjects.eoapplication.*;
import com.webobjects.eocontrol.*;
import com.webobjects.eointerface.*;
import com.webobjects.eointerface.swing.*;
import com.webobjects.foundation.*;
import java.awt.*;
import javax.swing.*;
import javax.swing.border.*;
import javax.swing.table.*;
import javax.swing.text.*;

public class _MyTableDocument_EOArchive_English extends com.webobjects.eoapplication.EOArchive {
    com.webobjects.eointerface.swing.EOFrame _eoFrame0;
    com.webobjects.eointerface.swing.EOTable _nsTableView0;
    com.webobjects.eointerface.swing.EOView _nsBox0, _nsBox1, _nsBox2, _nsBox3;
    javax.swing.JButton _nsButton0, _nsButton1, _nsButton2, _nsButton3;
    javax.swing.JPanel _nsView0;

    public _MyTableDocument_EOArchive_English(Object owner, NSDisposableRegistry registry) {
        super(owner, registry);
    }

    protected void _construct() {
        Object owner = _owner();
        EOArchive._ObjectInstantiationDelegate delegate = (owner instanceof EOArchive._ObjectInstantiationDelegate) ? (EOArchive._ObjectInstantiationDelegate)owner : null;
        Object replacement;

        super._construct();

        _nsBox3 = (com.webobjects.eointerface.swing.EOView)_registered(new com.webobjects.eointerface.swing.EOView(), "NSView");
        _nsBox2 = (com.webobjects.eointerface.swing.EOView)_registered(new com.webobjects.eointerface.swing.EOView(), "NSBox21");
        _nsBox1 = (com.webobjects.eointerface.swing.EOView)_registered(new com.webobjects.eointerface.swing.EOView(), "NSView");
        _nsBox0 = (com.webobjects.eointerface.swing.EOView)_registered(new com.webobjects.eointerface.swing.EOView(), "NSBox2");
        _nsButton3 = (javax.swing.JButton)_registered(new javax.swing.JButton("Remove"), "NSButton");
        _nsButton2 = (javax.swing.JButton)_registered(new javax.swing.JButton("Remove"), "NSButton");
        _nsButton1 = (javax.swing.JButton)_registered(new javax.swing.JButton("Add"), "NSButton1");
        _nsButton0 = (javax.swing.JButton)_registered(new javax.swing.JButton("Add"), "NSButton1");

        if ((delegate != null) && ((replacement = delegate.objectForOutletPath(this, "tableView")) != null)) {
            _nsTableView0 = (replacement == EOArchive._ObjectInstantiationDelegate.NullObject) ? null : (com.webobjects.eointerface.swing.EOTable)replacement;
            _replacedObjects.setObjectForKey(replacement, "_nsTableView0");
        } else {
            _nsTableView0 = (com.webobjects.eointerface.swing.EOTable)_registered(new com.webobjects.eointerface.swing.EOTable(), "NSTableView");
        }

        if ((delegate != null) && ((replacement = delegate.objectForOutletPath(this, "window")) != null)) {
            _eoFrame0 = (replacement == EOArchive._ObjectInstantiationDelegate.NullObject) ? null : (com.webobjects.eointerface.swing.EOFrame)replacement;
            _replacedObjects.setObjectForKey(replacement, "_eoFrame0");
        } else {
            _eoFrame0 = (com.webobjects.eointerface.swing.EOFrame)_registered(new com.webobjects.eointerface.swing.EOFrame(), "Window");
        }

        _nsView0 = (JPanel)_eoFrame0.getContentPane();
    }

    protected void _awaken() {
        super._awaken();
        _nsButton3.addActionListener((com.webobjects.eointerface.swing.EOControlActionAdapter)_registered(new com.webobjects.eointerface.swing.EOControlActionAdapter(_owner(), "removeRow", _nsButton3), ""));
        _nsButton2.addActionListener((com.webobjects.eointerface.swing.EOControlActionAdapter)_registered(new com.webobjects.eointerface.swing.EOControlActionAdapter(_owner(), "removeColumn", _nsButton2), ""));
        _nsButton1.addActionListener((com.webobjects.eointerface.swing.EOControlActionAdapter)_registered(new com.webobjects.eointerface.swing.EOControlActionAdapter(_owner(), "addColumn", _nsButton1), ""));
        _nsButton0.addActionListener((com.webobjects.eointerface.swing.EOControlActionAdapter)_registered(new com.webobjects.eointerface.swing.EOControlActionAdapter(_owner(), "addRow", _nsButton0), ""));

        if (_replacedObjects.objectForKey("_nsTableView0") == null) {
            _connect(_nsTableView0, _owner(), "delegate");
        }

        if (_replacedObjects.objectForKey("_eoFrame0") == null) {
            _connect(_eoFrame0, _owner(), "delegate");
        }

        if (_replacedObjects.objectForKey("_nsTableView0") == null) {
            _connect(_owner(), _nsTableView0, "tableView");
        }

        if (_replacedObjects.objectForKey("_eoFrame0") == null) {
            _connect(_owner(), _eoFrame0, "window");
        }

        if (_replacedObjects.objectForKey("_nsTableView0") == null) {
            _connect(_nsTableView0, _owner(), "dataSource");
        }
    }

    protected void _init() {
        super._init();
        if (!(_nsBox3.getLayout() instanceof EOViewLayout)) { _nsBox3.setLayout(new EOViewLayout()); }
        _nsButton2.setSize(61, 22);
        _nsButton2.setLocation(78, 5);
        ((EOViewLayout)_nsBox3.getLayout()).setAutosizingMask(_nsButton2, EOViewLayout.MinYMargin);
        _nsBox3.add(_nsButton2);
        _nsButton1.setSize(61, 22);
        _nsButton1.setLocation(12, 5);
        ((EOViewLayout)_nsBox3.getLayout()).setAutosizingMask(_nsButton1, EOViewLayout.MinYMargin);
        _nsBox3.add(_nsButton1);
        if (!(_nsBox2.getLayout() instanceof EOViewLayout)) { _nsBox2.setLayout(new EOViewLayout()); }
        _nsBox3.setSize(148, 35);
        _nsBox3.setLocation(2, 15);
        ((EOViewLayout)_nsBox2.getLayout()).setAutosizingMask(_nsBox3, EOViewLayout.MinYMargin);
        _nsBox2.add(_nsBox3);
        _nsBox2.setBorder(new com.webobjects.eointerface.swing._EODefaultBorder("Column", true, "Lucida Grande", 11, Font.PLAIN));
        if (!(_nsBox1.getLayout() instanceof EOViewLayout)) { _nsBox1.setLayout(new EOViewLayout()); }
        _nsButton3.setSize(61, 22);
        _nsButton3.setLocation(78, 5);
        ((EOViewLayout)_nsBox1.getLayout()).setAutosizingMask(_nsButton3, EOViewLayout.MinYMargin);
        _nsBox1.add(_nsButton3);
        _nsButton0.setSize(61, 22);
        _nsButton0.setLocation(12, 5);
        ((EOViewLayout)_nsBox1.getLayout()).setAutosizingMask(_nsButton0, EOViewLayout.MinYMargin);
        _nsBox1.add(_nsButton0);
        if (!(_nsBox0.getLayout() instanceof EOViewLayout)) { _nsBox0.setLayout(new EOViewLayout()); }
        _nsBox1.setSize(148, 35);
        _nsBox1.setLocation(2, 15);
        ((EOViewLayout)_nsBox0.getLayout()).setAutosizingMask(_nsBox1, EOViewLayout.MinYMargin);
        _nsBox0.add(_nsBox1);
        _nsBox0.setBorder(new com.webobjects.eointerface.swing._EODefaultBorder("Row", true, "Lucida Grande", 11, Font.PLAIN));
        _setFontForComponent(_nsButton3, "Lucida Grande", 11, Font.PLAIN);
        _nsButton3.setMargin(new Insets(0, 2, 0, 2));
        _setFontForComponent(_nsButton2, "Lucida Grande", 11, Font.PLAIN);
        _nsButton2.setMargin(new Insets(0, 2, 0, 2));
        _setFontForComponent(_nsButton1, "Lucida Grande", 11, Font.PLAIN);
        _nsButton1.setMargin(new Insets(0, 2, 0, 2));
        _setFontForComponent(_nsButton0, "Lucida Grande", 11, Font.PLAIN);
        _nsButton0.setMargin(new Insets(0, 2, 0, 2));

        if (_replacedObjects.objectForKey("_nsTableView0") == null) {
            _nsTableView0.table().setRowHeight(20);
        }

        if (!(_nsView0.getLayout() instanceof EOViewLayout)) { _nsView0.setLayout(new EOViewLayout()); }
        _nsTableView0.setSize(587, 387);
        _nsTableView0.setLocation(-7, 55);
        ((EOViewLayout)_nsView0.getLayout()).setAutosizingMask(_nsTableView0, EOViewLayout.WidthSizable | EOViewLayout.HeightSizable);
        _nsView0.add(_nsTableView0);
        _nsBox0.setSize(152, 52);
        _nsBox0.setLocation(10, -1);
        ((EOViewLayout)_nsView0.getLayout()).setAutosizingMask(_nsBox0, EOViewLayout.MaxXMargin | EOViewLayout.MaxYMargin);
        _nsView0.add(_nsBox0);
        _nsBox2.setSize(152, 52);
        _nsBox2.setLocation(164, -1);
        ((EOViewLayout)_nsView0.getLayout()).setAutosizingMask(_nsBox2, EOViewLayout.MaxXMargin | EOViewLayout.MaxYMargin);
        _nsView0.add(_nsBox2);

        if (_replacedObjects.objectForKey("_eoFrame0") == null) {
            _nsView0.setSize(573, 456);
            _eoFrame0.setTitle("Window");
            _eoFrame0.setLocation(238, 216);
            _eoFrame0.setSize(573, 456);
        }
    }
}