import 'package:flutter/material.dart';
import 'package:mobile/api_service.dart';
import 'package:mobile/lagu_model.dart';
import 'package:mobile/lagu_response.dart';

class LaguListScreen extends StatefulWidget {
  @override
  _LaguListScreenState createState() => _LaguListScreenState();
}

class _LaguListScreenState extends State<LaguListScreen> {
  var _searchMode = false, _isSubmitted = false;
  var _searchController = TextEditingController();

  List<LaguModel> _searchLagu = [];

  final ApiService apiService =
  ApiService(baseUrl: 'http://192.168.100.4/tpmobile');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff000080),
      appBar: AppBar(
        backgroundColor: Color(0xff000080),
        title: _searchMode
            ? _buildSearchBar()
            : _buildLaguListTitle(),
        actions: [
          _buildSearchIconButton(),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 1,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 3,
                  blurRadius: 2,
                  offset: Offset(0, 1),
                ),
              ],
            ),
          ),
          Expanded(
            child: _searchMode ? _buildSearchResults() : _buildLaguList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      child: Row(
        children: [
          Icon(
            Icons.music_note,
            color: Colors.white,
          ),
          SizedBox(width: 5),
          Expanded(
            child: TextField(
              autocorrect: false,
              autofocus: false,
              controller: _searchController,
              onChanged: _onSearchTextChanged,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 4),
                hintText: "Cari lagu atau artis kesukaanmu...",
                hintStyle: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.normal,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLaguListTitle() {
    return Row(
      children: [
        Icon(
          Icons.music_note,
          color: Colors.white,
        ),
        SizedBox(width: 5),
        Text(
          'Lagu List',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.5,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchIconButton() {
    return IconButton(
      onPressed: _toggleSearchMode,
      icon: Icon(
        _searchMode ? Icons.close : Icons.search,
        color: Colors.white,
      ),
    );
  }

  void _toggleSearchMode() {
    setState(() {
      if (_searchMode) {
        _isSubmitted = false;
        _searchMode = false;
        _searchController.clear();
        _searchLagu.clear();
      } else {
        _searchMode = true;
      }
      print("is Search mode: $_searchMode");
    });
  }

  void _onSearchTextChanged(String value) async {
    print("onChanged: $value");
    var productResponse = await apiService.searchLagu(value);

    setState(() {
      _isSubmitted = true;
      _searchLagu = productResponse!.listLagu;
    });

    print("Lagu ditemukan: ${_searchLagu.length}");
  }

  Widget _buildSearchResults() {
    return _searchLagu.length == 0 && _isSubmitted
        ? _buildNoResults()
        : _buildSearchList();
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.music_off,
            size: 100,
            color: Colors.white,
          ),
          SizedBox(height: 15),
          Text(
            "Ooops, lagu tidak ditemukan",
            style: TextStyle(fontSize: 18,color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchList() {
    return ListView.builder(
      itemCount: _searchLagu.length,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      itemBuilder: (context, index) {
        LaguModel lagu = _searchLagu[index];
        return _buildLaguListItem(lagu);
      },
    );
  }

  Widget _buildLaguList() {
    return FutureBuilder<ProductResponse?>(
      future: apiService.getProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.listLagu.isEmpty) {
          return Center(child: Text('No data available'));
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.listLagu.length,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            itemBuilder: (context, index) {
              LaguModel lagu = snapshot.data!.listLagu[index];
              return _buildLaguListItem(lagu);
            },
          );
        }
      },
    );
  }

  Widget _buildLaguListItem(LaguModel lagu) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return _buildLaguDetailDialog(lagu);
          },
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          border: _searchMode
              ? Border.all(color: Colors.deepPurple)
              : Border.all(color: const Color.fromARGB(255, 130, 101, 180)),
        ),
        child: ListTile(
          leading: Container(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                "${lagu.foto}",
                fit: BoxFit.cover,
                height: 50,
                width: 50,
              ),
            ),
          ),
          title: Text(lagu.judulLagu ?? ''),
          subtitle: Text(lagu.artis ?? ''),
          // Add other fields as needed
        ),
      ),
    );
  }

  Widget _buildLaguDetailDialog(LaguModel lagu) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Container(
        height: MediaQuery.of(context).size.height / 1.7,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Id: #${lagu.idLagu}",
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
            ),
            Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  "${lagu.foto}",
                  fit: BoxFit.cover,
                  height: 150,
                  width: 150,
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${lagu.judulLagu}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${lagu.artis}",
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  Text(
                    "${lagu.durasi}",
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Tanggal Rilis:",
                    style: TextStyle(fontSize: 13),
                  ),
                  Text(
                    "${lagu.tahunRilis}",
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
